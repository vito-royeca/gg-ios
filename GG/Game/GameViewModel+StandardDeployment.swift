//
//  GameViewModel+StandardDeployment.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension GameViewModel {
    static func createStandardDeployment(for player: GGPlayer) -> [[GGBoardPosition]] {
        var boardPositions = [[GGBoardPosition]]()
        
        for row in 0..<GameViewModel.rows {
            switch row {
            case 0:
                var rowArray = [GGBoardPosition]()
                
                for column in 0..<GameViewModel.columns {
                    let boardPosition = GGBoardPosition(row: row, column: column)
                    
                    switch column {
                    case 1:
                        boardPosition.unit = GGUnit(rank: .colonel1)
                    case 2:
                        boardPosition.unit = GGUnit(rank: .colonel2)
                    case 3:
                        boardPosition.unit = GGUnit(rank: .general1)
                    case 4:
                        boardPosition.unit = GGUnit(rank: .general2)
                    case 5:
                        boardPosition.unit = GGUnit(rank: .general3)
                    case 6:
                        boardPosition.unit = GGUnit(rank: .general4)
                    case 7:
                        boardPosition.unit = GGUnit(rank: .general5)
                    default:
                        ()
                    }
                    rowArray.append(boardPosition)
                }
                boardPositions.append(rowArray)
                
            case 1:
                var rowArray = [GGBoardPosition]()
                
                for column in 0..<GameViewModel.columns {
                    let boardPosition = GGBoardPosition(row: row, column: column)
                    
                    switch column {
                    case 1:
                        boardPosition.unit = GGUnit(rank: .spy)
                    case 2:
                        boardPosition.unit = player.spyB
                        boardPosition.player = player
                    case 3:
                        boardPosition.unit = player.sergeant
                        boardPosition.player = player
                    case 4:
                        boardPosition.unit = player.lieutenant1
                        boardPosition.player = player
                    case 5:
                        boardPosition.unit = player.lieutenant2
                        boardPosition.player = player
                    case 6:
                        boardPosition.unit = player.captain
                        boardPosition.player = player
                    case 7:
                        boardPosition.unit = player.major
                        boardPosition.player = player
                    default:
                        ()
                    }
                    rowArray.append(boardPosition)
                }
                boardPositions.append(rowArray)
                
            case 2:
                var rowArray = [GGBoardPosition]()
                
                for column in 0..<GameViewModel.columns {
                    let boardPosition = GGBoardPosition(row: row, column: column)
                    
                    switch column {
                    case 1:
                        boardPosition.unit = player.flag
                        boardPosition.player = player
                    case 2:
                        boardPosition.unit = player.privateA
                        boardPosition.player = player
                    case 3:
                        boardPosition.unit = player.privateB
                        boardPosition.player = player
                    case 4:
                        boardPosition.unit = player.privateC
                        boardPosition.player = player
                    case 5:
                        boardPosition.unit = player.privateD
                        boardPosition.player = player
                    case 6:
                        boardPosition.unit = player.privateE
                        boardPosition.player = player
                    case 7:
                        boardPosition.unit = player.privateF
                        boardPosition.player = player
                    default:
                        ()
                    }
                    rowArray.append(boardPosition)
                }
                boardPositions.append(rowArray)
                
            default:
                ()
            }
        }

        return boardPositions
    }
}
