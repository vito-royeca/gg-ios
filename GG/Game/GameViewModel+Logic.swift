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
            let lastAction = lastAction(from: move.fromPosition, to: newPosition)
            let emptyPosition = GGBoardPosition(row: move.fromPosition.row,
                                                column: move.fromPosition.column,
                                                player: move.fromPosition.player,
                                                action: lastAction,
                                                isLastAction: true)

            clearPossibleActions()
//            checkIfSeen(position: newPosition)
            
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
            
            print("\(moves.count)) \(move.fromPosition.description) \(lastAction ?? .fight) to (\(move.toPosition.row),\(move.toPosition.column)) ")

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
            
            let result = winningUnit == nil ? "draw" : ("\(winningUnit?.rank ?? .flag) wins")
            print("\(moves.count)) \(move.fromPosition.description) VS. \(move.toPosition.description): \(result)")
            
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
            fatalError("handleFight can't have nil values")
        }

        let result = unit1.rank.challenge(other: unit2.rank)
        
        switch result.challengeResult {
        case .win:
            player2.destroy(unit: unit2)
            return (player1, unit1, result.isGameOver)
        case .loose:
            player1.destroy(unit: unit1)
            return (player2, unit2, result.isGameOver)
        case .draw:
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
                    let targetPosition = boardPositions[row-1][column]
                    var action: GGAction?

                    if let targetPlayer = targetPosition.player {
                        if targetPlayer != player {
                            action = targetPosition.unit == nil ? .up : .fight
                        } else {
                            action = targetPosition.unit == nil ? .up : nil
                        }
                    } else {
                        action = .up
                    }
                    
                    if let action = action {
                        targetPosition.action = action

                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: targetPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if row + 1 <= (GameViewModel.rows - 1) {
                    let targetPosition = boardPositions[row+1][column]
                    var action: GGAction?

                    if let targetPlayer = targetPosition.player {
                        if targetPlayer != player {
                            action = targetPosition.unit == nil ? .down : .fight
                        } else {
                            action = targetPosition.unit == nil ? .down : nil
                        }
                    } else {
                        action = .down
                    }
                    
                    if let action = action {
                        targetPosition.action = action

                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: targetPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if column - 1 >= 0 {
                    let targetPosition = boardPositions[row][column-1]
                    var action: GGAction?

                    if let targetPlayer = targetPosition.player {
                        if targetPlayer != player {
                            action = targetPosition.unit == nil ? .left : .fight
                        } else {
                            action = targetPosition.unit == nil ? .left : nil
                        }
                    } else {
                        action = .left
                    }
                    
                    if let action = action {
                        targetPosition.action = action

                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: targetPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if column + 1 <= (GameViewModel.columns - 1) {
                    let targetPosition = boardPositions[row][column+1]
                    var action: GGAction?

                    if let targetPlayer = targetPosition.player {
                        if targetPlayer != player {
                            action = targetPosition.unit == nil ? .right : .fight
                        } else {
                            action = targetPosition.unit == nil ? .right : nil
                        }
                    } else {
                        action = .right
                    }
                    
                    if let action = action {
                        targetPosition.action = action

                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: targetPosition)
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

        let attackMove: GGAction = player.isBottomPlayer ? .up : .down
        let action = move.toPosition.action
        var rating = Double(0)
        
        if unit1.rank == .general5 ||  unit1.rank == .general4 || unit1.rank == .spy {
            if action == .fight || action == attackMove {
                rating = 15
            } else {
                rating = 13
            }
        } else if unit1.rank == .general3 ||  unit1.rank == .general2 || unit1.rank == .general1 {
            if action == .fight || action == attackMove {
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
                topPosition(from: move.fromPosition) :
                bottomPosition(from: move.fromPosition),
               let bottomLeft = leftPosition(from: position),
               bottomLeft.player == nil,
               let bottomRight = rightPosition(from: position),
               bottomRight.player == nil {
                if action == attackMove {
                    rating = 20
                }
            }
        } else {
            if action == .fight || action == attackMove {
                rating = 11
            } else {
                rating = 9
            }
        }
        
        // if enemy's flag is in the homeRow, prioritize eliminating enemy's flag or game is lost
        if let unit2 = move.toPosition.unit,
            unit2.rank == .flag {
            
            let homeRow = player.isBottomPlayer ? GameViewModel.columns - 1 : 0
            if move.toPosition.row == homeRow {
                rating = 30
            }
        }
        
        return rating
    }

}
