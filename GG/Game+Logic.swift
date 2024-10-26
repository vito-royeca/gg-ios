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
        let moves = posibleAIMoves()
        if !moves.isEmpty {
            let randomIndex = Int.random(in: 0..<moves.count)
            let randomMove = moves[randomIndex]
            doAIMove(to: randomMove)
        } else {
            print("No AI move")
        }
    }
    
    func doAIMove(to move: GGMove) {
        guard !isGameOver else {
            return
        }
        
        guard !(move.fromPosition.player?.isHuman ?? false) else {
            return
        }

        print("AI: \(move.fromPosition.unit?.rank) to (\(move.toPosition.row),\(move.toPosition.column))")
        
        switch move.toPosition.move ?? .fight {
        case .up, .down, .left, .right:
            let newPosition = BoardPosition(row: move.toPosition.row,
                                            column: move.toPosition.column,
                                            player: move.fromPosition.player,
                                            unit: move.fromPosition.unit)
            let emptyPosition = BoardPosition(row: move.fromPosition.row,
                                              column: move.fromPosition.column,
                                              move: lastMove(from: move.fromPosition, to: newPosition),
                                              isLastMove: true)

            removeAllPossibleMoves()
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
            
        case .fight:
            guard let aiPlayer = move.fromPosition.player,
                  let aiUnit = move.fromPosition.unit,
                  let humanPlayer = move.toPosition.player,
                  let humanUnit = move.toPosition.unit else {
                return
            }
            
            let (winningPlayer, winningUnit, isGameOver) = handleFight(player: aiPlayer,
                                                                       unit: aiUnit,
                                                                       vs: humanPlayer,
                                                                       with: humanUnit)
            let newPosition = BoardPosition(row: move.toPosition.row,
                                            column: move.toPosition.column,
                                            player: winningPlayer,
                                            unit: winningUnit)
            let emptyPosition = BoardPosition(row: move.fromPosition.row,
                                              column: move.fromPosition.column,
                                              move: lastMove(from: move.fromPosition, to: newPosition),
                                              isLastMove: true)

            removeAllPossibleMoves()
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
            
            self.winningPlayer = winningPlayer
            self.isGameOver = isGameOver
            updateCasualties()
        }
        
        checkGameProgress()
    }
    
    func posibleAIMoves() -> [GGMove] {
        var moves = [GGMove]()
        
        for row in 0..<Game.rows {
            let rowArray = boardPositions[row]

            for column in 0..<Game.columns {
                let boardPosition = rowArray[column]

                if boardPosition.player == player1 &&
                    boardPosition.unit != nil {
                    
                    let row = boardPosition.row
                    let column = boardPosition.column
                    
                    if row - 1 >= 0 {
                        if let player = boardPositions[row-1][column].player {
                            if player.isHuman {
                                
                                moves.append(GGMove(fromPosition: boardPosition,
                                                    toPosition: BoardPosition(row: row-1,
                                                                              column: column,
                                                                              player: player,
                                                                              unit: boardPosition.unit,
                                                                              move: .fight),
                                                    rating: 0))
                            }
                        } else {
                            moves.append(GGMove(fromPosition: boardPosition,
                                                toPosition: BoardPosition(row: row-1,
                                                                          column: column,
                                                                          move: .up),
                                                rating: 0))
                        }
                    }
                    
                    if row + 1 <= (Game.rows - 1) {
                        if let player = boardPositions[row+1][column].player {
                            if player.isHuman {
                                moves.append(GGMove(fromPosition: boardPosition,
                                                    toPosition: BoardPosition(row: row+1,
                                                                              column: column,
                                                                              player: player,
                                                                              unit: boardPosition.unit,
                                                                              move: .fight),
                                                    rating: 0))
                            }
                        } else {
                            moves.append(GGMove(fromPosition: boardPosition,
                                                toPosition: BoardPosition(row: row+1,
                                                                          column: column,
                                                                          move: .down),
                                                rating: 0))
                        }
                    }
                    
                    if column - 1 >= 0 {
                        if let player = boardPositions[row][column-1].player {
                            if player.isHuman {
                                moves.append(GGMove(fromPosition: boardPosition,
                                                    toPosition: BoardPosition(row: row,
                                                                              column: column-1,
                                                                              player: player,
                                                                              unit: boardPosition.unit,
                                                                              move: .fight),
                                                    rating: 0))
                            }
                        } else {
                            moves.append(GGMove(fromPosition: boardPosition,
                                                toPosition: BoardPosition(row: row,
                                                                          column: column-1,
                                                                          move: .left),
                                                rating: 0))
                        }
                    }
                    
                    if column + 1 <= (Game.columns - 1) {
                        if let player = boardPositions[row][column+1].player {
                            if player.isHuman {
                                moves.append(GGMove(fromPosition: boardPosition,
                                                    toPosition: BoardPosition(row: row,
                                                                              column: column+1,
                                                                              player: player,
                                                                              unit: boardPosition.unit,
                                                                              move: .fight),
                                                    rating: 0))
                            }
                        } else {
                            moves.append(GGMove(fromPosition: boardPosition,
                                                toPosition: BoardPosition(row: row,
                                                                          column: column+1,
                                                                          move: .right),
                                                rating: 0))
                        }
                    }
                }
            }
        }
        
        return moves
    }

    func boardPosition(of player: GGPlayer, rank: GGRank) -> [BoardPosition] {
        return []
    }
    
    func boardPosition(of unit: GGUnit) -> BoardPosition {
        return BoardPosition(row: 0, column: 0)
    }
}
