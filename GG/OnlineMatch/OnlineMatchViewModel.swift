//
//  OnlineMatchViewModel.swift
//  GG
//
//  Created by Vito Royeca on 11/6/24.
//

import SwiftUI
import Combine

class OnlineMatchViewModel: ObservableObject {
    @Published var game: FGame?

    private var firebaseRepository = FirebaseRepository()
    private var cancellables: Set<AnyCancellable> = []
    private var playerID = ""

    @MainActor
    func joinGame(playerID: String, positions: [[GGBoardPosition]]) async throws {
        self.playerID = playerID

        if let gameToJoin = await getGame() {
            
            game = gameToJoin
            game?.player2ID = playerID
            game?.player2Positions = positions
            // TODO: determine who plays first
//            game?.activePlayerID = game.player1ID
            
            await update(game: game!)
        } else {
            try await createNewGame(playerID: playerID, positions: positions)
        }

        await listenForChanges(in: game!.id)
    }
    
    func update(game: FGame) async {
        do {
            try firebaseRepository.saveDocument(data: game, to: .games)
        } catch {
            print("Error updating  online game", error.localizedDescription)
        }
    }
    
    func quitGame() {
        guard let game else {
            return
        }

        firebaseRepository.deleteDocument(with: game.id, from: .games)
    }

    @MainActor
    private func createNewGame(playerID: String, positions: [[GGBoardPosition]]) async throws {
        game = FGame(id: UUID().uuidString,
                     player1ID: playerID,
                     player1Positions: positions)
        
        await self.update(game: game!)
    }
    
    private func getGame() async -> FGame? {
        try? await firebaseRepository.getDocuments(from: .games,
                                                   equalToFilter: ["player1ID": playerID])?.first
    }
    
    @MainActor
    private func listenForChanges(in gameID: String) async {
        do {
            try await firebaseRepository.listen(from: .games, documentId: gameID)
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
