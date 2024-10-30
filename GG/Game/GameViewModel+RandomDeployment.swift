//
//  GameViewModel+RandomDeployment.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension GameViewModel {
    static func createRandomDeployment(for player: GGPlayer) -> [[BoardPosition]] {
        var boardPositions = [[BoardPosition]]()
        
        var availablePositions = [player.general5, player.general4, player.general3, player.general2, player.general1,
                                  player.colonel2, player.colonel1, player.major, player.captain, player.lieutenant2,
                                  player.lieutenant1, player.sergeant, player.privateA, player.privateB, player.privateC,
                                  player.privateD, player.privateE, player.privateF, player.spyA, player.spyB, player.flag]
        
        var rowArray1 = [BoardPosition]()
        var rowColumns1 = [0,1,2,3,4,5,6,7,8]
        var rowArray2 = [BoardPosition]()
        var rowColumns2 = [0,1,2,3,4,5,6,7,8]
        var rowArray3 = [BoardPosition]()
        var rowColumns3 = [0,1,2,3,4,5,6,7,8]
        
        while !availablePositions.isEmpty {
            let randomRow = Int.random(in: 0..<3)
            let randomRank = Int.random(in: 0..<availablePositions.count)
            
            
            switch randomRow {
            case 0:
                if rowArray1.count < GameViewModel.columns {
                    let rank = availablePositions.remove(at: randomRank)
                    let randomColumn = Int.random(in: 0..<rowColumns1.count)
                    let column = rowColumns1.remove(at: randomColumn)
                    let newPosition = BoardPosition(row: randomRow,
                                                    column: column,
                                                    player: player,
                                                    unit: rank)
                    rowArray1.append(newPosition)
                }
            case 1:
                if rowArray2.count < GameViewModel.columns {
                    let rank = availablePositions.remove(at: randomRank)
                    let randomColumn = Int.random(in: 0..<rowColumns2.count)
                    let column = rowColumns2.remove(at: randomColumn)
                    let newPosition = BoardPosition(row: randomRow,
                                                    column: column,
                                                    player: player,
                                                    unit: rank)
                    rowArray2.append(newPosition)
                }
            case 2:
                if rowArray3.count < GameViewModel.columns {
                    let rank = availablePositions.remove(at: randomRank)
                    let randomColumn = Int.random(in: 0..<rowColumns3.count)
                    let column = rowColumns3.remove(at: randomColumn)
                    let newPosition = BoardPosition(row: randomRow,
                                                    column: column,
                                                    player: player,
                                                    unit: rank)
                    rowArray3.append(newPosition)
                }
            default:
                ()
            }
        }

        boardPositions.append(rowArray1)
        boardPositions.append(rowArray2)
        boardPositions.append(rowArray3)
        
        return boardPositions
    }
}
