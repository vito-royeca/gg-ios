//
//  GameViewModel+UI.swift
//  GG
//
//  Created by Vito Royeca on 10/27/24.
//

import Foundation

extension GameViewModel {
    func createBoard() {
        boardPositions = [[GGBoardPosition]]()
        
        for row in 0..<GameViewModel.rows {
            var rowArray = [GGBoardPosition]()
            
            for column in 0..<GameViewModel.columns {
                let boardPosition = GGBoardPosition(row: row, column: column)
                rowArray.append(boardPosition)
            }
            boardPositions.append(rowArray)
        }
    }
    
    func deployUnits() {
        // assign the player to the positions
        for boardPosition in player1Positions ?? [] {
            boardPosition.player = player1

            // invert the rows and columns for player1
            let rowCount = 3-1
            let columnCount = GameViewModel.columns-1
            let reverseRow = rowCount-boardPosition.row
            let reverseColumn = columnCount-boardPosition.column
            boardPosition.row = reverseRow
            boardPosition.column = reverseColumn
        }
        for boardPosition in player2Positions ?? [] {
            boardPosition.player = player2
        }
        
        // assign the positions to the board
        for row in 0..<GameViewModel.rows {
            let rowArray = boardPositions[row]

            switch row {
            case 0, 1, 2:
                if let player1Positions {
                    for column in 0..<GameViewModel.columns {
                        if let boardPosition = player1Positions.first(where: { $0.row == row && $0.column == column}) {
                            rowArray[column].player = boardPosition.player
                            rowArray[column].rank = boardPosition.rank
                        }
                    }
                }
                
            case 5,6,7:
                if let player2Positions {
                    for column in 0..<GameViewModel.columns {
                        if let boardPosition = player2Positions.first(where: { $0.row == row-5 && $0.column == column}) {
                            rowArray[column].player = boardPosition.player
                            rowArray[column].rank = boardPosition.rank
                        }
                    }
                }
            default:
                ()
            }
        }
    }

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
                    action = targetPosition.rank == nil ? .up : .fight
                } else {
                    action = targetPosition.rank == nil ? .up : nil
                }
            } else {
                action = .up
            }
            
            if let action {
                targetPosition.action = action
            }
        }
        
        if row + 1 <= (GameViewModel.rows - 1) {
            let targetPosition = boardPositions[row+1][column]
            var action: GGAction?

            if let targetPlayer = targetPosition.player {
                if targetPlayer != position.player {
                    action = targetPosition.rank == nil ? .down : .fight
                } else {
                    action = targetPosition.rank == nil ? .down : nil
                }
            } else {
                action = .down
            }
            
            if let action {
                targetPosition.action = action
            }
        }
        
        if column - 1 >= 0 {
            let targetPosition = boardPositions[row][column-1]
            var action: GGAction?

            if let targetPlayer = targetPosition.player {
                if targetPlayer != position.player {
                    action = targetPosition.rank == nil ? .left : .fight
                } else {
                    action = targetPosition.rank == nil ? .left : nil
                }
            } else {
                action = .left
            }
            
            if let action {
                targetPosition.action = action
            }
        }
        
        if column + 1 <= (GameViewModel.columns - 1) {
            let targetPosition = boardPositions[row][column+1]
            var action: GGAction?

            if let targetPlayer = targetPosition.player {
                if targetPlayer != position.player {
                    action = targetPosition.rank == nil ? .right : .fight
                } else {
                    action = targetPosition.rank == nil ? .right : nil
                }
            } else {
                action = .right
            }
            
            if let action {
                targetPosition.action = action
            }
        }
    }
    
    func clearPossibleActions() {
        guard !boardPositions.isEmpty else {
            return
        }

        for row in 0..<GameViewModel.rows {
            for column in 0..<GameViewModel.columns {
                let boardPosition = boardPositions[row][column]

                boardPositions[row][column] = GGBoardPosition(row: row,
                                                              column: column,
                                                              player: boardPosition.player,
                                                              rank: boardPosition.rank)
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
        player1Casualties = [[GGRank]]()
        player2Casualties = [[GGRank]]()
        
        var rowArray = [GGRank]()
        var count = 0
        
        for casualty in player1.casualties {
            rowArray.append(casualty)
            count += 1

            if count == 7 {
                player1Casualties.append(rowArray)
                rowArray = [GGRank]()
                count = 0
            }
        }
        player1Casualties.append(rowArray)
        
        rowArray = [GGRank]()
        count = 0
        
        for casualty in player2.casualties {
            rowArray.append(casualty)
            count += 1

            if count == 7 {
                player2Casualties.append(rowArray)
                rowArray = [GGRank]()
                count = 0
            }
        }
        player2Casualties.append(rowArray)
    }
    
    func revealUnit() -> Bool {
        if gameType == .aiVsAI {
            true
        } else {
            isGameOver
        }
    }
    
    func revealUnit(for boardPosition: GGBoardPosition) -> Bool {
        if gameType == .aiVsAI {
            true
        } else {
            ((boardPosition.player?.isBottomPlayer ?? false) ? true : isGameOver)
        }
    }
}
