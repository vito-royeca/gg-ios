//
//  Game+StandardDeployment.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension Game {
    func createStandardDeployment(for player: GGPlayer) -> [[BoardPosition]] {
        var boardPositions = [[BoardPosition]]()
        
        for row in 0..<Game.rows {
            switch row {
            case 0:
                var rowArray = [BoardPosition]()
                
                for column in 0..<Game.columns {
                    let boardPosition = BoardPosition(row: row, column: column)
                    
                    switch column {
                    case 1:
                        boardPosition.unit = player.colonel1
                        boardPosition.player = player
                    case 2:
                        boardPosition.unit = player.colonel2
                        boardPosition.player = player
                    case 3:
                        boardPosition.unit = player.general1
                        boardPosition.player = player
                    case 4:
                        boardPosition.unit = player.general2
                        boardPosition.player = player
                    case 5:
                        boardPosition.unit = player.general3
                        boardPosition.player = player
                    case 6:
                        boardPosition.unit = player.general4
                        boardPosition.player = player
                    case 7:
                        boardPosition.unit = player.general5
                        boardPosition.player = player
                    default:
                        ()
                    }
                    rowArray.append(boardPosition)
                }
                boardPositions.append(rowArray)
                
            case 1:
                var rowArray = [BoardPosition]()
                
                for column in 0..<Game.columns {
                    let boardPosition = BoardPosition(row: row, column: column)
                    
                    switch column {
                    case 1:
                        boardPosition.unit = player.spyA
                        boardPosition.player = player
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
                var rowArray = [BoardPosition]()
                
                for column in 0..<Game.columns {
                    let boardPosition = BoardPosition(row: row, column: column)
                    
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
