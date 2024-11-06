//
//  PlayerManager.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

enum PlayerManagerProvider {
    case google
}

class PlayerManager: ObservableObject {
    // MARK: - Static properties

    public static let shared = PlayerManager()
    

    // MARK: - Properties
    
    @Published var player: FPlayer?
    @Published var isLoggedIn = false

    private var firebaseRepository = FirebaseRepository()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    private init() {
        check()
    }
    
    // MARK: - Methods
    
    @MainActor
    func checkStatus() async throws {
        if let user = Auth.auth().currentUser {
            if player == nil {
                player = try? await firebaseRepository.getDocument(from: .players, id: user.uid)
            }
            isLoggedIn = true
        } else {
            player = nil
            isLoggedIn = false
        }
    }

    func check() {
        Task {
            try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            try await checkStatus()
        }
    }
    
    @MainActor
    func signIn() async throws {
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)
            
            guard let idToken = result.user.idToken?.tokenString else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: result.user.accessToken.tokenString)
            
            try await self.auth(with: credential)
        } catch {
            print("Error signing in: \(error)")
        }
    }
    
    @MainActor
    func auth(with credential: AuthCredential) async throws {
        try await Auth.auth().signIn(with: credential)
        try await checkStatus()
    }

    func signOut() async throws {
        do {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
        
        try await checkStatus()
    }
    
    func createPlayer(username: String) {
        guard let user = Auth.auth().currentUser else {
            return
        }

        let newPlayer = FPlayer(id: user.uid,
                                username: username,
                                wins: 0,
                                losses: 0,
                                draws: 0)
        do {
            try firebaseRepository.saveDocument(data: newPlayer, to: .players)
            player = newPlayer
        } catch {
            print(error)
        }
    }
}
