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
                self.doOnlineMove(game: onlineGame)
            }
            .store(in: &cancellables)
    }
    
    func doOnlineMove(game: FGame?) {
        guard let game,
              let lastMove = game.lastMove,
              let player = PlayerManager.shared.player,
              game.activePlayerID == player.id  else {
            return
        }
        
        let reversedFromPosition = GGBoardPosition(from: lastMove.fromPosition)
        reversedFromPosition.row = GameViewModel.rows-1-reversedFromPosition.row
        reversedFromPosition.column = GameViewModel.columns-1-reversedFromPosition.column
        reversedFromPosition.player = player1

        let reversedToPosition = GGBoardPosition(from: lastMove.toPosition)
        reversedToPosition.row = GameViewModel.rows-1-reversedToPosition.row
        reversedToPosition.column = GameViewModel.columns-1-reversedToPosition.column
        reversedToPosition.action = lastMove.toPosition.action?.opposite
        
        let targetBoardPisition = boardPositions[reversedToPosition.row][reversedToPosition.column]
        reversedToPosition.player = targetBoardPisition.player
        reversedToPosition.rank = targetBoardPisition.rank
        
        let reversedMove = GGMove(fromPosition: reversedFromPosition, toPosition: reversedToPosition)
        
        execute(move: reversedMove)
        checkFlagHomeRun()
        checkGameProgress()
    }
}
