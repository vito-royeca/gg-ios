//
//  UnitsDeployerViewModel.swift
//  GG
//
//  Created by Vito Royeca on 10/30/24.
//

import SwiftUI

class UnitsDeployerViewModel: ObservableObject {
    @Published var player = GGPlayer(homeRow: GameViewModel.rows-1)
    @Published var playerPositions = [[GGBoardPosition]]()
    @Published var boardPositions = [[GGBoardPosition]]()
    
    func createBoard() {
        boardPositions = [[GGBoardPosition]]()
        
        for row in 0..<GameViewModel.rows {
            var rowArray = [GGBoardPosition]()
            
            for column in 0..<GameViewModel.columns {
                let boardPosition = GGBoardPosition(row: row, column: column)
                rowArray.append(boardPosition)
            }
            boardPositions.append(rowArray)
        }
    }

    func mobilizePlayer() {
        player = GGPlayer(homeRow: GameViewModel.rows-1)
        playerPositions = GameViewModel.createStandardDeployment()
        
        // assign the player to the positions
        for rowArray in playerPositions {
            for column in 0..<rowArray.count {
                rowArray[column].player = player
            }
        }
        
        // assign the positions to the board
        for row in 0..<GameViewModel.rows {
            let rowArray = boardPositions[row]

            switch row {
            // bottom 3 rows
            case 5,6,7:
                for column in 0..<GameViewModel.columns {
                    for boardPosition in playerPositions[row-5] {
                        if boardPosition.column == column {
                            rowArray[column].player = boardPosition.player
                            rowArray[column].rank = boardPosition.rank
                        }
                    }
                }

            default:
                ()
            }
        }
    }
    
    func updatePlayerPositions() {
        var row5 = [GGBoardPosition]()
        var row6 = [GGBoardPosition]()
        var row7 = [GGBoardPosition]()
        
        for row in 0..<GameViewModel.rows {
            switch row {
            case 5:
                for column in 0..<GameViewModel.columns {
                    let boardPosition = boardPositions[row][column]
                    
                    if boardPosition.player != nil
                        && boardPosition.rank != nil {
                        row5.append(GGBoardPosition(from: boardPosition))
                    }
                }
            case 6:
                for column in 0..<GameViewModel.columns {
                    let boardPosition = boardPositions[row][column]
                    
                    if boardPosition.player != nil
                        && boardPosition.rank != nil {
                        row6.append(GGBoardPosition(from: boardPosition))
                    }
                }
            case 7:
                for column in 0..<GameViewModel.columns {
                    let boardPosition = boardPositions[row][column]
                    
                    if boardPosition.player != nil
                        && boardPosition.rank != nil {
                        row7.append(GGBoardPosition(from: boardPosition))
                    }
                }
            default:
                ()
            }
        }
        
        playerPositions = [row5, row6, row7]
    }
}
