//
//  GameViewModel+UI.swift
//  GG
//
//  Created by Vito Royeca on 10/27/24.
//

import Foundation

extension GameViewModel {
    func addPossibleActions(for board: GGBoardPosition) {
        clearPossibleActions()
        
        guard board.player?.isBottomPlayer ?? false else {
            return
        }

        let row = board.row
        let column = board.column
        
        if row - 1 >= 0 {
            if let player = boardPositions[row-1][column].player {
                if !player.isBottomPlayer {
                    boardPositions[row-1][column].action = .fight
                }
            } else {
                boardPositions[row-1][column].action = .up
            }
        }
        
        if row + 1 <= (GameViewModel.rows - 1) {
            if let player = boardPositions[row+1][column].player {
                if !player.isBottomPlayer {
                    boardPositions[row+1][column].action = .fight
                }
            } else {
                boardPositions[row+1][column].action = .down
            }
        }
        
        if column - 1 >= 0 {
            if let player = boardPositions[row][column-1].player {
                if !player.isBottomPlayer {
                    boardPositions[row][column-1].action = .fight
                }
            } else {
                boardPositions[row][column-1].action = .left
            }
        }
        
        if column + 1 <= (GameViewModel.columns - 1) {
            if let player = boardPositions[row][column+1].player {
                if !player.isBottomPlayer {
                    boardPositions[row][column+1].action = .fight
                }
            } else {
                boardPositions[row][column+1].action = .right
            }
        }
    }
    
    func clearPossibleActions() {
        for row in 0..<GameViewModel.rows {
            for column in 0..<GameViewModel.columns {
                let boardPosition = boardPositions[row][column]

                boardPositions[row][column] = GGBoardPosition(row: row,
                                                              column: column,
                                                              player: boardPosition.player,
                                                              unit: boardPosition.unit)
            }
        }
    }
    
    func lastAction(from fromBoard: GGBoardPosition, to toBoard: GGBoardPosition) -> GameAction? {
        if toBoard.column == fromBoard.column {
            if toBoard.row > fromBoard.row {
                return .down
            } else {
                return .up
            }
        }
        
        if toBoard.row == fromBoard.row {
            if toBoard.column > fromBoard.column {
                return .right
            } else {
                return .left
            }
        }
        
        return nil
    }

    func updateCasualties() {
        player1Casualties = [[GGUnit]]()
        player2Casualties = [[GGUnit]]()
        
        var rowArray = [GGUnit]()
        var count = 0
        
        for casualty in player1.casualties {
            rowArray.append(casualty)
            count += 1

            if count == 7 {
                player1Casualties.append(rowArray)
                rowArray = [GGUnit]()
                count = 0
            }
        }
        player1Casualties.append(rowArray)
        
        rowArray = [GGUnit]()
        count = 0
        
        for casualty in player2.casualties {
            rowArray.append(casualty)
            count += 1

            if count == 7 {
                player2Casualties.append(rowArray)
                rowArray = [GGUnit]()
                count = 0
            }
        }
        player2Casualties.append(rowArray)
    }
}
