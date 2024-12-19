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

    var player1: FPlayer?
    var player2: FPlayer?
    var player1Positions: [GGBoardPosition]?
    var player2Positions: [GGBoardPosition]?

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
            // determine who plays first
            game?.activePlayerID = Int.random(in: 0..<2) == 0 ? game?.player1ID : game?.player2ID
            
            await update(game: game!)
        } else {
            try await createNewGame(playerID: playerID, positions: positions)
        }

        await listenForChanges(in: game!.id)
    }
    
    private func update(game: FGame) async {
        do {
            try firebaseManager.saveDocument(data: game, to: .games)
        } catch {
            print("Error updating  online game: ", error.localizedDescription)
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
    
    @MainActor
    func startGame() async throws {
        try await configureGame()

        guard let game,
              let player1,
              let player2,
              let player1Positions,
              let player2Positions else {
            return
        }

        ViewManager.shared.changeView(to: .humanVsHumanGame(game.id,
                                                            player1,
                                                            player2,
                                                            player1Positions,
                                                            player2Positions,
                                                            game.activePlayerID ?? ""))
    }

    private func configureGame() async throws {
        guard let game,
              let player1ID = game.player1ID,
              let player2ID = game.player2ID else {
            return
        }

        player1 = try? await firebaseManager.getDocuments(from: .players,
                                                          equalToFilter: ["id": player1ID])?.first
        player2 = try? await firebaseManager.getDocuments(from: .players,
                                                          equalToFilter: ["id": player2ID])?.first
        
        var tmpPlayer: FPlayer?
        if player1?.isLoggedInUser ?? false {
            tmpPlayer = player2
            
            player2 = player1
            player2Positions = game.player1Positions
            
            player1 = tmpPlayer
            player1Positions = game.player2Positions
        } else {
            player1Positions = game.player1Positions
            player2Positions = game.player2Positions
        }
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
