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
                })
                .store(in: &cancellables)
            
        } catch {
            print("Error listening ", error.localizedDescription)
        }
    }
}
