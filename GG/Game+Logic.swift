//
//  Game+Logic.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension Game {
    func doAIMove() {
        // 1) check if flag is in danger
        // 2) if flag is in danger, destroy flag's attacker
        // 3) if flag is in danger, retreat flag
        // 4) calculate highest move
        // 5) execute highest move
        
        
        // just do a random move
        let positions = movableAIPositions()
        if !positions.isEmpty {
            let randomIndex = Int.random(in: 0..<positions.count)
            let randomPosition = positions[randomIndex]
            doAIMove(to: randomPosition)
        } else {
            print("No AI move")
        }
    }
    
    func doAIMove(to boardPosition: BoardPosition) {
        guard !isGameOver else {
            return
        }
        
        guard !(boardPosition.player?.isHuman ?? false) else {
            return
        }

        var origRow = boardPosition.row
        var origColumn = boardPosition.column

        switch boardPosition.move ?? .fight {
        case .up:
            origRow += 1
        case .down:
            origRow -= 1
        case .left:
            origColumn += 1
        case .right:
            origColumn -= 1
        default:
            ()
        }
        
        let origBoardPosition = boardPositions[origRow][origColumn]
        if origBoardPosition.unit == nil {
            print("why nil?")
        }
        print("AI: \(origBoardPosition.unit?.rank) to (\(boardPosition.row),\(boardPosition.column))")
        
        switch boardPosition.move ?? .fight {
        case .up, .down, .left, .right:
            let newBoardPosition = BoardPosition(row: boardPosition.row,
                                                 column: boardPosition.column,
                                                 player: origBoardPosition.player,
                                                 unit: origBoardPosition.unit)
            let emptyBoardPosition = BoardPosition(row: origRow,
                                                   column: origColumn,
                                                   move: lastMove(from: origBoardPosition, to: newBoardPosition),
                                                   isLastMove: true)

            removeAllPossibleMoves()
            boardPositions[origRow][origColumn] = emptyBoardPosition
            boardPositions[boardPosition.row][boardPosition.column] = newBoardPosition
            
        case .fight:
            guard let aiPlayer = origBoardPosition.player,
                  let aiUnit = origBoardPosition.unit,
                  let humanPlayer = boardPosition.player,
                  let humanUnit = boardPosition.unit else {
                return
            }
            
            let (winningPlayer, winningUnit, isGameOver) = handleFight(player: aiPlayer,
                                                                       unit: aiUnit,
                                                                       vs: humanPlayer,
                                                                       with: humanUnit)
            let newBoardPosition = BoardPosition(row: boardPosition.row,
                                                 column: boardPosition.column,
                                                 player: winningPlayer,
                                                 unit: winningUnit)
            let emptyBoardPosition = BoardPosition(row: origRow,
                                                   column: origColumn,
                                                   move: lastMove(from: origBoardPosition, to: newBoardPosition),
                                                   isLastMove: true)

            removeAllPossibleMoves()
            boardPositions[origRow][origColumn] = emptyBoardPosition
            boardPositions[boardPosition.row][boardPosition.column] = newBoardPosition
            
            self.winningPlayer = winningPlayer
            self.isGameOver = isGameOver
            updateCasualties()
        }
        
        checkGameProgress()
    }
    
    func movableAIPositions() -> [BoardPosition] {
        var movablePositions = [BoardPosition]()
        
        for row in 0..<Game.rows {
            let rowArray = boardPositions[row]

            for column in 0..<Game.columns {
                let boardPosition = rowArray[column]

                if boardPosition.player == player1 &&
                    boardPosition.unit != nil {
                    
                    let row = boardPosition.row
                    let column = boardPosition.column
                    
                    if row - 1 >= 0 /*&&
                        movablePositions.filter({ $0.row == row-1 && $0.column == column }).isEmpty*/ {
                        if let player = boardPositions[row-1][column].player {
                            if player.isHuman {
                                
                                movablePositions.append(BoardPosition(row: row-1,
                                                                      column: column,
                                                                      player: player,
                                                                      unit: boardPosition.unit,
                                                                      move: .fight))
                            }
                        } else {
                            movablePositions.append(BoardPosition(row: row-1,
                                                                  column: column,
                                                                  move: .up))
                        }
                    }
                    
                    if row + 1 <= (Game.rows - 1) /*&&
                        movablePositions.filter({ $0.row == row+1 && $0.column == column }).isEmpty*/ {
                        if let player = boardPositions[row+1][column].player {
                            if player.isHuman {
                                movablePositions.append(BoardPosition(row: row+1,
                                                                      column: column,
                                                                      player: player,
                                                                      unit: boardPosition.unit,
                                                                      move: .fight))
                            }
                        } else {
                            movablePositions.append(BoardPosition(row: row+1,
                                                                  column: column,
                                                                  move: .down))
                        }
                    }
                    
                    if column - 1 >= 0 /*&&
                        movablePositions.filter({ $0.row == row && $0.column == column-1 }).isEmpty*/ {
                        if let player = boardPositions[row][column-1].player {
                            if player.isHuman {
                                movablePositions.append(BoardPosition(row: row,
                                                                      column: column-1,
                                                                      player: player,
                                                                      unit: boardPosition.unit,
                                                                      move: .fight))
                            }
                        } else {
                            movablePositions.append(BoardPosition(row: row,
                                                                  column: column-1,
                                                                  move: .left))
                        }
                    }
                    
                    if column + 1 <= (Game.columns - 1) /*&&
                        movablePositions.filter({ $0.row == row && $0.column == column+1 }).isEmpty*/ {
                        if let player = boardPositions[row][column+1].player {
                            if player.isHuman {
                                movablePositions.append(BoardPosition(row: row,
                                                                      column: column+1,
                                                                      player: player,
                                                                      unit: boardPosition.unit,
                                                                      move: .fight))
                            }
                        } else {
                            movablePositions.append(BoardPosition(row: row,
                                                                  column: column+1,
                                                                  move: .right))
                        }
                    }
                }
            }
        }
        
        return movablePositions
    }
    
    func boardPosition(of player: GGPlayer, rank: GGRank) -> [BoardPosition] {
        return []
    }
    
    func boardPosition(of unit: GGUnit) -> BoardPosition {
        return BoardPosition(row: 0, column: 0)
    }
}
