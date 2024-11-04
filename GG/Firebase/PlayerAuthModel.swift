//
//  PlayerAuthModel.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

enum PlayerAuthProvider {
    case google
}

class PlayerAuthModel: ObservableObject {
    
    @Published var player: FPlayer?
    @Published var playerID = ""
    
    private var firebaseRepository = FirebaseRepository()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        check()
    }
    
    func checkStatus() {
        if let user = Auth.auth().currentUser {
            playerID = user.uid
        } else{
            playerID = ""
        }
    }
    
    func check() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            self.checkStatus()
        }
    }
    
    @MainActor
    func getPlayer() async throws  {
        guard player == nil else {
            return
        }

        let user = GIDSignIn.sharedInstance.currentUser
        
        guard let user = user,
              let id = user.userID else {
            return
        }
        
        player = try? await firebaseRepository.getDocument(from: .players, id: id)
    }

    func createPlayer(username: String) {
        guard !playerID.isEmpty else {
            return
        }

        let newPlayer = FPlayer(id: playerID,
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

    func signIn() {
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            self.checkStatus()

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            self.auth(with: credential)
        }
    }
    
    func auth(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { result, error in
            self.checkStatus()
        }
    }

    func signOut(){
        let firebaseAuth = Auth.auth()

        do {
            GIDSignIn.sharedInstance.signOut()
            try firebaseAuth.signOut()
            playerID = ""
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        checkStatus()
    }
}
