//
//  GameViewModel+StandardDeployment.swift
//  GG
//
//  Created by Vito Royeca on 10/24/24.
//

import Foundation

extension GameViewModel {
    static func createStandardDeployment() -> [GGBoardPosition] {
        var boardPositions = [GGBoardPosition]()
        
        for row in 0..<3 {
            switch row {
            case 0:
                for column in 0..<GameViewModel.columns {
                    let boardPosition = GGBoardPosition(row: row, column: column)
                    
                    switch column {
                    case 1:
                        boardPosition.rank = .colonel1
                    case 2:
                        boardPosition.rank = .colonel2
                    case 3:
                        boardPosition.rank = .general1
                    case 4:
                        boardPosition.rank = .general2
                    case 5:
                        boardPosition.rank = .general3
                    case 6:
                        boardPosition.rank = .general4
                    case 7:
                        boardPosition.rank = .general5
                    default:
                        ()
                    }
                    boardPositions.append(boardPosition)
                }
                
            case 1:
                for column in 0..<GameViewModel.columns {
                    let boardPosition = GGBoardPosition(row: row, column: column)
                    
                    switch column {
                    case 1:
                        boardPosition.rank = .spy
                    case 2:
                        boardPosition.rank = .spy
                    case 3:
                        boardPosition.rank = .sergeant
                    case 4:
                        boardPosition.rank = .lieutenant1
                    case 5:
                        boardPosition.rank = .lieutenant2
                    case 6:
                        boardPosition.rank = .captain
                    case 7:
                        boardPosition.rank = .major
                    default:
                        ()
                    }
                    boardPositions.append(boardPosition)
                }
                
            case 2:
                for column in 0..<GameViewModel.columns {
                    let boardPosition = GGBoardPosition(row: row, column: column)
                    
                    switch column {
                    case 1:
                        boardPosition.rank = .flag
                    case 2:
                        boardPosition.rank = .private_
                    case 3:
                        boardPosition.rank = .private_
                    case 4:
                        boardPosition.rank = .private_
                    case 5:
                        boardPosition.rank = .private_
                    case 6:
                        boardPosition.rank = .private_
                    case 7:
                        boardPosition.rank = .private_
                    default:
                        ()
                    }
                    boardPositions.append(boardPosition)
                }
                
            default:
                ()
            }
        }

        return boardPositions
    }
}
