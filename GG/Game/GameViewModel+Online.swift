//
//  GameViewModel+Online.swift
//  GG
//
//  Created by Vito Royeca on 11/10/24.
//

import Foundation

extension GameViewModel {
    @MainActor
    func listenForChanges(in gameID: String) async {
        do {
            try await FirebaseManager.shared.listen(from: .games, documentId: gameID)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        print("Error ", error.localizedDescription)
                    }
                }, receiveValue: { [weak self] game in
                    self?.game = game
                    self?.doEnemyMove()
                })
                .store(in: &cancellables)
            
        } catch {
            print("Error listening: ", error.localizedDescription)
        }
    }
    
    func doEnemyMove() {
        guard let game,
              let lastMove = game.lastMove else {
            return
        }
        
        execute(move: lastMove)
    }

    func updateGame() {
        guard var game,
              let lastMove = moves.first else {
            return
        }
        
        game.activePlayerID = game.player1ID
        game.lastMove = lastMove
        
        do {
            try FirebaseManager.shared.saveDocument(data: game, to: .games)
        } catch {
            print(error)
        }
    }
}
