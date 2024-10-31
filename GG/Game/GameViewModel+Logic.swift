//
//  GameViewModel+Logic.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension GameViewModel {
    func execute(move: GGMove) {
        guard !isGameOver else {
            clearPossibleActions()
            return
        }

        moves.append(move)

        switch move.toPosition.action ?? .fight {
        case .up, .down, .left, .right:
            let newPosition = GGBoardPosition(row: move.toPosition.row,
                                              column: move.toPosition.column,
                                              player: move.fromPosition.player,
                                              unit: move.fromPosition.unit)
            let emptyPosition = GGBoardPosition(row: move.fromPosition.row,
                                                column: move.fromPosition.column,
                                                player: move.fromPosition.player,
                                                action: lastAction(from: move.fromPosition, to: newPosition),
                                                isLastAction: true)

            clearPossibleActions()
//            checkIfSeen(position: newPosition)
            
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
//            print("Fight: \(unit1.rank) @(\(position1.row),\(position1.column)) VS. \(unit2.rank) @(\(position2.row),\( position2.column)) -> \(unit1.rank) @(\( position1.row),\( position1.column)) wins")
            print("\(moves.count). \(move.toPosition.action ?? .fight) ")

        case .fight:
            let (winningPlayer, winningUnit, isGameOver) = handleFight(move.fromPosition,
                                                                       vs: move.toPosition)
            let newPosition = GGBoardPosition(row: move.toPosition.row,
                                              column: move.toPosition.column,
                                              player: winningPlayer,
                                              unit: winningUnit)
            let emptyPosition = GGBoardPosition(row: move.fromPosition.row,
                                                column: move.fromPosition.column,
                                                player: move.fromPosition.player,
                                                action: lastAction(from: move.fromPosition, to: newPosition),
                                                isLastAction: true)

            clearPossibleActions()
//            checkIfSeen(position: newPosition)
                
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
            
            self.winningPlayer = winningPlayer
            self.isGameOver = isGameOver
            updateCasualties()
        }
    }
    
    func handleFight(_ position1: GGBoardPosition, vs position2: GGBoardPosition) -> (GGPlayer?, GGUnit?, Bool) {
        guard let player1 = position1.player,
              let player2 = position2.player,
              let unit1 = position1.unit,
              let unit2 = position2.unit else {
            print("some nil units")
            return (nil, nil, false)
        }

        let result = unit1.rank.challenge(other: unit2.rank)
        
        switch result.challengeResult {
        case .win:
            player2.destroy(unit: unit2)
            return (player1, unit1, result.isGameOver)
        case .loose:
            print("Fight: \(unit1.rank) @(\(position1.row),\(position1.column)) VS. \(unit2.rank) @(\( position2.row),\( position2.column)) -> \(unit2.rank) @(\(position2.row),\( position2.column)) wins")
            player1.destroy(unit: unit1)
            return (player2, unit2, result.isGameOver)
        case .draw:
            print("Fight: \(unit1.rank) @(\(position1.row),\(position1.column)) VS. \(unit2.rank) @(\(position2.row),\( position2.column)) -> draw")
            player1.destroy(unit: unit1)
            player2.destroy(unit: unit2)
            return (nil, nil, result.isGameOver)
        }
    }

    func posibleMoves(of player: GGPlayer) -> [GGMove] {
        var moves = [GGMove]()
        
        for row in 0..<GameViewModel.rows {
            let rowArray = boardPositions[row]

            for column in 0..<GameViewModel.columns {
                let boardPosition = rowArray[column]

                guard boardPosition.player == player else {
                    continue
                }
                
                if row - 1 >= 0 {
                    let toPosition = boardPositions[row-1][column]
                    var action: GameAction?

                    if let toPlayer = toPosition.player {
                        if toPlayer != player {
                            action = toPosition.unit == nil ? .up : .fight
                        } else {
                            action = toPosition.unit == nil ? .up : nil
                        }
                    } else {
                        action = .up
                    }
                    
                    if let action = action {
                        toPosition.action = action

                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: toPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if row + 1 <= (GameViewModel.rows - 1) {
                    let toPosition = boardPositions[row+1][column]
                    var action: GameAction?
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer != player {
                            action = toPosition.unit == nil ? .down : .fight
                        } else {
                            action = toPosition.unit == nil ? .down : nil
                        }
                    } else {
                        action = .down
                    }
                    
                    if let action = action {
                        toPosition.action = action

                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: toPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if column - 1 >= 0 {
                    let toPosition = boardPositions[row][column-1]
                    var action: GameAction?

                    if let toPlayer = toPosition.player {
                        if toPlayer != player {
                            action = toPosition.unit == nil ? .left : .fight
                        } else {
                            action = toPosition.unit == nil ? .left : nil
                        }
                    } else {
                        action = .left
                    }
                    
                    if let action = action {
                        toPosition.action = action

                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: toPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if column + 1 <= (GameViewModel.columns - 1) {
                    let toPosition = boardPositions[row][column+1]
                    var action: GameAction?
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer != player {
                            action = toPosition.unit == nil ? .right : .fight
                        } else {
                            action = toPosition.unit == nil ? .right : nil
                        }
                    } else {
                        action = .right
                    }
                    
                    if let action = action {
                        toPosition.action = action

                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: toPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
            }
        }
        
        return moves
    }
    
//    func checkIfSeen(position: BoardPosition) {
//        if let player = position.player,
//           player.isHuman,
//           let seenPosition = player1.seenPositions.filter({ $0.row == position.row && $0.column == position.column}).first {
//            player1.seenPositions.removeAll(where: { $0.row == seenPosition.row && $0.column == seenPosition.column})
//            player1.seenPositions.append(position)
//            print("seen=\(player1.seenPositions.count)")
//        }
//    }

    func rate(move: GGMove) -> Double {
        guard let player =  move.fromPosition.player,
              let unit1 = move.fromPosition.unit else {
            return 0
        }

        let atackMove: GameAction = player.isBottomPlayer ? .up : .down
        let action = move.toPosition.action
        var rating = Double(0)
        
        if unit1.rank == .general5 ||  unit1.rank == .general4 || unit1.rank == .spy {
            if action == .fight || action == atackMove {
                rating = 15
            } else {
                rating = 13
            }
        } else if unit1.rank == .general3 ||  unit1.rank == .general2 || unit1.rank == .general1 {
            if action == .fight || action == atackMove {
                rating = 14
            } else {
                rating = 12
            }
        } else if unit1.rank == .flag {
            // if there is nearby enemy units, flee
            if let position = topPosition(from: move.fromPosition) {
                if position.player != player {
                    rating = 1
                } else {
                    rating = 2
                }
            }
            
            if let position = bottomPosition(from: move.fromPosition) {
                if position.player != player {
                    rating = 1
                } else {
                    rating = 2
                }
            }
            
            if let position = leftPosition(from: move.fromPosition) {
                if position.player != player {
                    rating = 1
                } else {
                    rating = 2
                }
            }
            
            if let position = rightPosition(from: move.fromPosition) {
                if position.player != player {
                    rating = 1
                } else {
                    rating = 2
                }
            }
            
            // occupy opposing homeRow
            if let position = player.isBottomPlayer ?
                topPosition(from: move.fromPosition) : bottomPosition(from: move.fromPosition),
               let bottomLeft = leftPosition(from: position),
               bottomLeft.player == nil,
               let bottomRight = rightPosition(from: position),
               bottomRight.player == nil {
                if action == atackMove {
                    rating = 20
                }
            }
        } else {
            if action == .fight || action == atackMove {
                rating = 11
            } else {
                rating = 9
            }
        }
        
        // enemy's flag is in the baseline, prioritize eliminating enemy's flag or game is lost
        if let unit2 = move.toPosition.unit,
            unit2.rank == .flag {
            if move.toPosition.row == 0 {
                rating = 30
            }
        }
        
        return rating
    }

}
