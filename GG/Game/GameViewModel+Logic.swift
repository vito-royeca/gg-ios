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
                                              rank: move.fromPosition.rank)
            let lastAction = lastAction(from: move.fromPosition, to: newPosition)
            let emptyPosition = GGBoardPosition(row: move.fromPosition.row,
                                                column: move.fromPosition.column,
                                                player: move.fromPosition.player,
                                                action: lastAction,
                                                isLastAction: true)

            clearPossibleActions()
            
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
            
            print("\(moves.count)) \(move.fromPosition.description) \(lastAction ?? .fight) to (\(move.toPosition.row),\(move.toPosition.column)) ")

        case .fight:
            let (winningPlayer, winningRank, isGameOver) = handleFight(move.fromPosition,
                                                                       vs: move.toPosition)
            let newPosition = GGBoardPosition(row: move.toPosition.row,
                                              column: move.toPosition.column,
                                              player: winningPlayer,
                                              rank: winningRank)
            let emptyPosition = GGBoardPosition(row: move.fromPosition.row,
                                                column: move.fromPosition.column,
                                                player: move.fromPosition.player,
                                                action: lastAction(from: move.fromPosition, to: newPosition),
                                                isLastAction: true)

            clearPossibleActions()
                
            boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
            boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
            
            let result = winningRank == nil ? "draw" : ("\(winningRank ?? .flag) wins")
            print("\(moves.count)) \(move.fromPosition.description) VS. \(move.toPosition.description): \(result)")
            
            self.winningPlayer = winningPlayer
            self.isGameOver = isGameOver
            updateCasualties()
        }
    }
    
    func handleFight(_ position1: GGBoardPosition, vs position2: GGBoardPosition) -> (GGPlayer?, GGRank?, Bool) {
        guard let player1 = position1.player,
              let player2 = position2.player,
              let rank1 = position1.rank,
              let rank2 = position2.rank else {
            fatalError("handleFight can't have nil values")
        }

        let result = rank1.challenge(other: rank2)
        
        switch result.challengeResult {
        case .win:
            player2.casualties.append(rank2)
            return (player1, rank1, result.isGameOver)
        case .loose:
            player1.casualties.append(rank1)
            return (player2, rank2, result.isGameOver)
        case .draw:
            player1.casualties.append(rank1)
            player2.casualties.append(rank2)
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
                            action = targetPosition.rank == nil ? .up : .fight
                        } else {
                            action = targetPosition.rank == nil ? .up : nil
                        }
                    } else {
                        action = .up
                    }
                    
                    if let action {
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
                            action = targetPosition.rank == nil ? .down : .fight
                        } else {
                            action = targetPosition.rank == nil ? .down : nil
                        }
                    } else {
                        action = .down
                    }
                    
                    if let action {
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
                            action = targetPosition.rank == nil ? .left : .fight
                        } else {
                            action = targetPosition.rank == nil ? .left : nil
                        }
                    } else {
                        action = .left
                    }
                    
                    if let action {
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
                            action = targetPosition.rank == nil ? .right : .fight
                        } else {
                            action = targetPosition.rank == nil ? .right : nil
                        }
                    } else {
                        action = .right
                    }
                    
                    if let action {
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
    
    func rate(move: GGMove) -> Double {
        guard let player =  move.fromPosition.player,
              let rank1 = move.fromPosition.rank else {
            return 0
        }

        let attackMove: GGAction = player.isBottomPlayer ? .up : .down
        let action = move.toPosition.action
        var rating = Double(0)
        
        if rank1 == .general5 ||  rank1 == .general4 || rank1 == .spy {
            if action == .fight || action == attackMove {
                rating = 15
            } else {
                rating = 13
            }
        } else if rank1 == .general3 || rank1 == .general2 || rank1 == .general1 {
            if action == .fight || action == attackMove {
                rating = 14
            } else {
                rating = 12
            }
        } else if rank1 == .flag {
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
        if let rank2 = move.toPosition.rank,
            rank2 == .flag {
            
            let homeRow = player.isBottomPlayer ? GameViewModel.columns - 1 : 0
            if move.toPosition.row == homeRow {
                rating = 30
            }
        }
        
        return rating
    }

    func topPosition(from board: GGBoardPosition) -> GGBoardPosition? {
        if board.row - 1 >= 0 {
            return boardPositions[board.row-1].first(where: { $0.column == board.column })
        }
        return nil
    }

    func bottomPosition(from board: GGBoardPosition) -> GGBoardPosition? {
        if board.row + 1 <= (GameViewModel.rows - 1) {
            return boardPositions[board.row+1].first(where: { $0.column == board.column })
        }
        return nil
    }

    func leftPosition(from board: GGBoardPosition) -> GGBoardPosition? {
        if board.column - 1 >= 0 {
            return boardPositions[board.row].first(where: { $0.column == board.column-1 })
        }
        return nil
    }

    func rightPosition(from board: GGBoardPosition) -> GGBoardPosition? {
        if board.column + 1 <= (GameViewModel.columns - 1) {
            return boardPositions[board.row].first(where: { $0.column == board.column+1 })
        }
        return nil
    }
}
