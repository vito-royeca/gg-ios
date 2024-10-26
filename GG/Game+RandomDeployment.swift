//
//  Game+RandomDeployment.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension Game {
    func createRandomDeployment(for player: GGPlayer) -> [[BoardPosition]] {
        var boardPositions = [[BoardPosition]]()
        
        var availablePositions = [player.general5, player.general4, player.general3, player.general2, player.general1,
                                  player.colonel2, player.colonel1, player.major, player.captain, player.lieutenant2,
                                  player.lieutenant1, player.sergeant, player.privateA, player.privateB, player.privateC,
                                  player.privateD, player.privateE, player.privateF, player.spyA, player.spyB, player.flag]
        
        // add the three rows
        var rowArray1 = [BoardPosition]()
        var rowArray2 = [BoardPosition]()
        var rowArray3 = [BoardPosition]()
        
        while !availablePositions.isEmpty {
            let randomRow = Int.random(in: 0..<3)
            let randomColumn = Int.random(in: 0..<Game.columns)
            let randomRank = Int.random(in: 0..<availablePositions.count)
            
            let rank = availablePositions.remove(at: randomRank)
            let newPosition = BoardPosition(row: randomRow,
                                            column: randomColumn,
                                            player: player,
                                            unit: rank)
            
            switch randomRow {
            case 0:
                if rowArray1.count <= Game.columns {
                    rowArray1.append(newPosition)
                }
            case 1:
                if rowArray2.count <= Game.columns {
                    rowArray2.append(newPosition)
                }
            case 2:
                if rowArray3.count <= Game.columns {
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
