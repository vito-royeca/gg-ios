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
    @Published var player1: FPlayer?
    @Published var player2: FPlayer?

    private var cancellables: Set<AnyCancellable> = []
    private var playerID = ""
    private let firebaseManager = FirebaseManager.shared

    @MainActor
    func joinGame(playerID: String, positions: [GGBoardPosition]) async throws {
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
            try firebaseManager.saveDocument(data: game, to: .games)
        } catch {
            print("Error updating  online game", error.localizedDescription)
        }
    }
    
    func quitGame() {
        guard let game else {
            return
        }

        firebaseManager.deleteDocument(with: game.id, from: .games)
    }

    @MainActor
    private func createNewGame(playerID: String, positions: [GGBoardPosition]) async throws {
        game = FGame(id: UUID().uuidString,
                     player1ID: playerID,
                     player2ID: "",
                     player1Positions: positions)
        
        await self.update(game: game!)
    }
    
    private func getGame() async -> FGame? {
        try? await firebaseManager.getDocuments(from: .games,
                                                equalToFilter: ["player2ID": ""],
                                                notEqualToFilter: ["player1ID": playerID])?.first
    }
    
    func isReadyToStart() -> Bool {
        guard let game,
            let player1ID = game.player1ID,
            let player2ID = game.player2ID,
            !player1ID.isEmpty,
            !player2ID.isEmpty,
            game.player1Positions != nil,
            game.player2Positions != nil else {
            return false
        }
        
        return true
    }
    @MainActor
    func getGameConfig() async throws -> ViewKey {
        try await getPlayers()
        
        guard let game,
              let player1,
              let player2 else {
            throw FirebaseError.unknownError
        }

        let enemyPlayer = player1.isLoggedInUser ? player2 : player1
        let myPlayer = player1.isLoggedInUser ? player1 : player2
        let enemyPositions = player1.isLoggedInUser ? game.player2Positions : game.player1Positions
        let myPositions = player1.isLoggedInUser ? game.player1Positions : game.player2Positions
        
        return .humanVsHumanGame(game.id,
                                 enemyPlayer,
                                 myPlayer,
                                 enemyPositions ?? [],
                                 myPositions ?? [])
    }
    
    @MainActor
    func getPlayers() async throws {
        guard let game,
              let player1ID = game.player1ID,
              let player2ID = game.player2ID else {
            return
        }

        player1 = try? await firebaseManager.getDocuments(from: .players,
                                                          equalToFilter: ["id": player1ID])?.first
        player2 = try? await firebaseManager.getDocuments(from: .players,
                                                          equalToFilter: ["id": player2ID])?.first
    }
    
    @MainActor
    private func listenForChanges(in gameID: String) async {
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
