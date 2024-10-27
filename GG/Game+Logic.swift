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
            
            execute(move: randomMove)
        }
    }
    
    func execute(move: GGMove) {
        guard !isGameOver else {
            clearPossibleActions()
            return
        }
        
        switch move.toPosition.action ?? .fight {
        case .up, .down, .left, .right:
            let newPosition = BoardPosition(row: move.toPosition.row,
                                            column: move.toPosition.column,
                                            player: move.fromPosition.player,
                                            unit: move.fromPosition.unit)
            let emptyPosition = BoardPosition(row: move.fromPosition.row,
                                              column: move.fromPosition.column,
                                              action: lastAction(from: move.fromPosition, to: newPosition),
                                              isLastAction: true)

            clearPossibleActions()
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
            
        case .fight:
            let (winningPlayer, winningUnit, isGameOver) = handleFight(move.fromPosition,
                                                                       vs: move.toPosition)
            let newPosition = BoardPosition(row: move.toPosition.row,
                                            column: move.toPosition.column,
                                            player: winningPlayer,
                                            unit: winningUnit)
            let emptyPosition = BoardPosition(row: move.fromPosition.row,
                                              column: move.fromPosition.column,
                                              action: lastAction(from: move.fromPosition, to: newPosition),
                                              isLastAction: true)

            clearPossibleActions()
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
            
            self.winningPlayer = winningPlayer
            self.isGameOver = isGameOver
            updateCasualties()
        }
        
        checkGameProgress()
    }
    
    func handleFight(_ position1: BoardPosition, vs position2: BoardPosition) -> (GGPlayer?, GGUnit?, Bool) {
        guard let player1 = position1.player,
              let player2 = position2.player,
              let unit1 = position1.unit,
              let unit2 = position2.unit else {
            print("some nil units")
            return (nil, nil, false)
        }

        print("Fight: \(unit1.description) (\( position1.row),\( position1.column)) VS. \(unit2.description) (\( position2.row),\( position2.column))")
        let result = unit1.challenge(other: unit2)
        
        switch result.challengeResult {
        case .win:
            print("\(unit1.description) wins")
            player2.destroy(unit: unit2)
            return (player1, unit1, result.isGameOver)
        case .loose:
            print("\(unit2.description) wins")
            player1.destroy(unit: unit1)
            return (player2, unit2, result.isGameOver)
        case .draw:
            print("Draw")
            player1.destroy(unit: unit1)
            player2.destroy(unit: unit2)
            return (nil, nil, result.isGameOver)
        }
    }

    func posibleAIMoves() -> [GGMove] {
        var moves = [GGMove]()
        
        for row in 0..<Game.rows {
            let rowArray = boardPositions[row]

            for column in 0..<Game.columns {
                let boardPosition = rowArray[column]

                guard let player = boardPosition.player,
                      !player.isHuman else {
                    continue
                }
                
                if row - 1 >= 0 {
                    let toPosition = boardPositions[row-1][column]
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer.isHuman {
                            toPosition.action = .fight
                            moves.append(GGMove(fromPosition: boardPosition,
                                                toPosition: toPosition,
                                                rating: 0))
                        }
                    } else {
                        toPosition.action = .up
                        moves.append(GGMove(fromPosition: boardPosition,
                                            toPosition: toPosition,
                                            rating: 0))
                    }
                }
                
                if row + 1 <= (Game.rows - 1) {
                    let toPosition = boardPositions[row+1][column]
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer.isHuman {
                            toPosition.action = .fight
                            moves.append(GGMove(fromPosition: boardPosition,
                                                toPosition: toPosition,
                                                rating: 0))
                        }
                    } else {
                        toPosition.action = .down
                        moves.append(GGMove(fromPosition: boardPosition,
                                            toPosition: toPosition,
                                            rating: 0))
                    }
                }
                
                if column - 1 >= 0 {
                    let toPosition = boardPositions[row][column-1]
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer.isHuman {
                            toPosition.action = .fight
                            moves.append(GGMove(fromPosition: boardPosition,
                                                toPosition: toPosition,
                                                rating: 0))
                        }
                    } else {
                        toPosition.action = .left
                        moves.append(GGMove(fromPosition: boardPosition,
                                            toPosition: toPosition,
                                            rating: 0))
                    }
                }
                
                if column + 1 <= (Game.columns - 1) {
                    let toPosition = boardPositions[row][column+1]
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer.isHuman {
                            toPosition.action = .fight
                            moves.append(GGMove(fromPosition: boardPosition,
                                                toPosition: toPosition,
                                                rating: 0))
                        }
                    } else {
                        toPosition.action = .right
                        moves.append(GGMove(fromPosition: boardPosition,
                                            toPosition: toPosition,
                                            rating: 0))
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
