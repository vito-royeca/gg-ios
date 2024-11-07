//
//  GameViewModel+RandomDeployment.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension GameViewModel {
    static func createRandomDeployment() -> [GGBoardPosition] {
        var boardPositions = [GGBoardPosition]()
        
        var ranks:[GGRank] = [.general5, .general4, .general3, .general2, .general1,
                              .colonel2, .colonel1, .major, .captain, .lieutenant2,
                              .lieutenant1, .sergeant, .private_, .private_, .private_,
                              .private_, .private_, .private_, .spy, .spy, .flag]
        
        var rowArray1 = [GGBoardPosition]()
        var rowColumns1 = [0,1,2,3,4,5,6,7,8]
        var rowArray2 = [GGBoardPosition]()
        var rowColumns2 = [0,1,2,3,4,5,6,7,8]
        var rowArray3 = [GGBoardPosition]()
        var rowColumns3 = [0,1,2,3,4,5,6,7,8]
        
        while !ranks.isEmpty {
            let randomRow = Int.random(in: 0..<3)
            let randomRank = Int.random(in: 0..<ranks.count)
            
            switch randomRow {
            case 0:
                if rowArray1.count < GameViewModel.columns {
                    let rank = ranks.remove(at: randomRank)
                    let randomColumn = Int.random(in: 0..<rowColumns1.count)
                    let column = rowColumns1.remove(at: randomColumn)
                    let newPosition = GGBoardPosition(row: randomRow,
                                                      column: column,
                                                      rank: rank)
                    rowArray1.append(newPosition)
                }
            case 1:
                if rowArray2.count < GameViewModel.columns {
                    let rank = ranks.remove(at: randomRank)
                    let randomColumn = Int.random(in: 0..<rowColumns2.count)
                    let column = rowColumns2.remove(at: randomColumn)
                    let newPosition = GGBoardPosition(row: randomRow,
                                                      column: column,
                                                      rank: rank)
                    rowArray2.append(newPosition)
                }
            case 2:
                if rowArray3.count < GameViewModel.columns {
                    let rank = ranks.remove(at: randomRank)
                    let randomColumn = Int.random(in: 0..<rowColumns3.count)
                    let column = rowColumns3.remove(at: randomColumn)
                    let newPosition = GGBoardPosition(row: randomRow,
                                                      column: column,
                                                      rank: rank)
                    rowArray3.append(newPosition)
                }
            default:
                ()
            }
        }

        boardPositions.append(contentsOf: rowArray1)
        boardPositions.append(contentsOf: rowArray2)
        boardPositions.append(contentsOf: rowArray3)
        
        return boardPositions
    }
}
