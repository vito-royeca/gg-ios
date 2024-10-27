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
            var movesDict = [Double: [GGMove]]()
            moves.forEach {
                if var array = movesDict[$0.rating] {
                    array.append($0)
                    movesDict[$0.rating] = array
                } else {
                    movesDict[$0.rating] = [$0]
                }
            }
            let ratingKeys = movesDict.keys.sorted(by: { $0 > $1 })
            if let first = ratingKeys.first,
                let highestMoves = movesDict[first] {
                let randomIndex = Int.random(in: 0..<highestMoves.count)
                let randomMove = highestMoves[randomIndex]
                execute(move: randomMove)
            } else {
                let randomIndex = Int.random(in: 0..<moves.count)
                let randomMove = moves[randomIndex]
                
                execute(move: randomMove)
            }
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
//            checkIfSeen(position: newPosition)
            
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
//            checkIfSeen(position: newPosition)
                
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
                            let move = GGMove(fromPosition: boardPosition,
                                              toPosition: toPosition)
                            move.rating = rate(move: move)
                            moves.append(move)
                        }
                    } else {
                        toPosition.action = .up
                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: toPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if row + 1 <= (Game.rows - 1) {
                    let toPosition = boardPositions[row+1][column]
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer.isHuman {
                            toPosition.action = .fight
                            let move = GGMove(fromPosition: boardPosition,
                                              toPosition: toPosition)
                            move.rating = rate(move: move)
                            moves.append(move)
                        }
                    } else {
                        toPosition.action = .down
                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: toPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if column - 1 >= 0 {
                    let toPosition = boardPositions[row][column-1]
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer.isHuman {
                            toPosition.action = .fight
                            let move = GGMove(fromPosition: boardPosition,
                                              toPosition: toPosition)
                            move.rating = rate(move: move)
                            moves.append(move)
                        }
                    } else {
                        toPosition.action = .left
                        let move = GGMove(fromPosition: boardPosition,
                                          toPosition: toPosition)
                        move.rating = rate(move: move)
                        moves.append(move)
                    }
                }
                
                if column + 1 <= (Game.columns - 1) {
                    let toPosition = boardPositions[row][column+1]
                    
                    if let toPlayer = toPosition.player {
                        if toPlayer.isHuman {
                            toPosition.action = .fight
                            let move = GGMove(fromPosition: boardPosition,
                                              toPosition: toPosition)
                            move.rating = rate(move: move)
                            moves.append(move)
                        }
                    } else {
                        toPosition.action = .right
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
        guard let unit1 = move.fromPosition.unit,
//              let unit2 = move.toPosition.unit,
              let action = move.toPosition.action else {
            return 0
        }
        
        let multiplier = Double.random(in: 1..<6)
        var rating = Double(0)
        
        if unit1.rank == .general5 ||  unit1.rank == .general4 || unit1.rank == .spy {
            if action == .fight || action == .down {
                rating = 15
            } else {
                rating = 13
            }
        } else if unit1.rank == .general3 ||  unit1.rank == .general2 || unit1.rank == .general1 {
            if action == .fight || action == .down {
                rating = 14
            } else {
                rating = 12
            }
        } else if unit1.rank == .flag {
            // check nearby enemy units
            if let position = topPosition(from: move.fromPosition),
               let player = position.player,
               player.isHuman {
                rating = action == .fight ? 1 : 20
            }
            
            if let position = bottomPosition(from: move.fromPosition),
               let player = position.player,
               player.isHuman {
                rating = action == .fight ? 1 : 20
            }
            
            if let position = leftPosition(from: move.fromPosition),
               let player = position.player,
               player.isHuman {
                rating = action == .fight ? 1 : 20
            }
            
            if let position = rightPosition(from: move.fromPosition),
               let player = position.player,
               player.isHuman {
                rating = action == .fight ? 1 : 20
            }
            
            // check bottom position if empty
            if let position = bottomPosition(from: move.fromPosition),
               let bottomLeft = leftPosition(from: position),
               bottomLeft.player == nil,
               let bottomRight = rightPosition(from: position),
               bottomRight.player == nil {
                if action == .down {
                    rating = 20
                }
            }
        } else {
            if action == .fight || action == .down {
                rating = 11
            } else {
                rating = 10
            }
        }
        
        return rating * multiplier
    }

    func topPosition(from board: BoardPosition) -> BoardPosition? {
        if board.row - 1 >= 0 {
            return boardPositions[board.row-1].first(where: { $0.column == board.column })
        }
        return nil
    }
    func bottomPosition(from board: BoardPosition) -> BoardPosition? {
        if board.row + 1 <= (Game.rows - 1) {
            return boardPositions[board.row+1].first(where: { $0.column == board.column })
        }
        return nil
    }
    func leftPosition(from board: BoardPosition) -> BoardPosition? {
        if board.column-1 >= 0 {
            return boardPositions[board.row].first(where: { $0.column == board.column-1 })
        }
        return nil
    }
    func rightPosition(from board: BoardPosition) -> BoardPosition? {
        if board.column+1 <= (Game.columns - 1) {
            return boardPositions[board.row].first(where: { $0.column == board.column+1 })
        }
        return nil
    }
    
    func boardPosition(of player: GGPlayer, rank: GGRank) -> [BoardPosition] {
        return []
    }
    
    func boardPosition(of unit: GGUnit) -> BoardPosition {
        return BoardPosition(row: 0, column: 0)
    }
}
