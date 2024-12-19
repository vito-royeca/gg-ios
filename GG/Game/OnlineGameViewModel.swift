//
//  OnlineGameViewModel.swift
//  GG
//
//  Created by Vito Royeca on 11/14/24.
//

import SwiftUI
import Combine

class OnlineGameViewModel: ObservableObject {
    @Published var game: FGame?

    private var cancellables: Set<AnyCancellable> = []
    private let firebaseManager = FirebaseManager.shared
    private var listenHandler: (() -> Void)?

    func quit() {
        guard let game else {
            return
        }

        firebaseManager.deleteDocument(with: game.id, from: .games)
    }

    func send(lastMove: GGMove) {
        guard var game else {
            return
        }
        
        game.activePlayerID = game.activePlayerID == game.player1ID ? game.player2ID : game.player1ID
        game.lastMove = lastMove
        
        do {
            try FirebaseManager.shared.saveDocument(data: game, to: .games)
        } catch {
            print(error)
        }
    }

    func endTurn() {
        guard var game else {
            return
        }
        
        game.activePlayerID = game.activePlayerID == game.player1ID ? game.player2ID : game.player1ID
        
        do {
            try FirebaseManager.shared.saveDocument(data: game, to: .games)
        } catch {
            print(error)
        }
    }

    @MainActor
    func listenForChanges(in gameID: String) async {
        do {
            try await firebaseManager.listen(from: .games, documentId: gameID)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        print("Error ", error.localizedDescription)
                    }
                }, receiveValue: { [weak self] game in
                    self?.game = game
                })
                .store(in: &cancellables)
            
        } catch {
            print("Error listening ", error.localizedDescription)
        }
    }
}
