//
//  GameViewModel+UI.swift
//  GG
//
//  Created by Vito Royeca on 10/27/24.
//

import Foundation

extension GameViewModel {
    func addPossibleActions(for position: GGBoardPosition) {
        clearPossibleActions()
        
        guard position.player?.isBottomPlayer ?? false else {
            return
        }

        let row = position.row
        let column = position.column
        
        if row - 1 >= 0 {
            let targetPosition = boardPositions[row-1][column]
            var action: GGAction?

            if let targetPlayer = targetPosition.player {
                if targetPlayer != position.player {
                    action = targetPosition.unit == nil ? .up : .fight
                } else {
                    action = targetPosition.unit == nil ? .up : nil
                }
            } else {
                action = .up
            }
            
            if let action = action {
                targetPosition.action = action
            }
        }
        
        if row + 1 <= (GameViewModel.rows - 1) {
            let targetPosition = boardPositions[row+1][column]
            var action: GGAction?

            if let targetPlayer = targetPosition.player {
                if targetPlayer != position.player {
                    action = targetPosition.unit == nil ? .down : .fight
                } else {
                    action = targetPosition.unit == nil ? .down : nil
                }
            } else {
                action = .down
            }
            
            if let action = action {
                targetPosition.action = action
            }
        }
        
        if column - 1 >= 0 {
            let targetPosition = boardPositions[row][column-1]
            var action: GGAction?

            if let targetPlayer = targetPosition.player {
                if targetPlayer != position.player {
                    action = targetPosition.unit == nil ? .left : .fight
                } else {
                    action = targetPosition.unit == nil ? .left : nil
                }
            } else {
                action = .left
            }
            
            if let action = action {
                targetPosition.action = action
            }
        }
        
        if column + 1 <= (GameViewModel.columns - 1) {
            let targetPosition = boardPositions[row][column+1]
            var action: GGAction?

            if let targetPlayer = targetPosition.player {
                if targetPlayer != position.player {
                    action = targetPosition.unit == nil ? .right : .fight
                } else {
                    action = targetPosition.unit == nil ? .right : nil
                }
            } else {
                action = .right
            }
            
            if let action = action {
                targetPosition.action = action
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
    
    func lastAction(from fromBoard: GGBoardPosition, to toBoard: GGBoardPosition) -> GGAction? {
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
