//
//  GameViewModel+Online.swift
//  GG
//
//  Created by Vito Royeca on 11/12/24.
//

import Foundation
import SwiftUI
import Combine

extension GameViewModel {
    func observeOnlineGame() {
        onlineModel?.$game
            .map { $0 }
            .assign(to: &$game)
        
        $game
            .drop(while: { $0 == nil })
            .sink { onlineGame in
                self.syncOnline(game: onlineGame)
            }
            .store(in: &cancellables)
    }
    
    func syncOnline(game: FGame?) {
        
    }
}
