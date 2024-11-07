//
//  UnitsDeployerViewModel.swift
//  GG
//
//  Created by Vito Royeca on 10/30/24.
//

import SwiftUI

class UnitsDeployerViewModel: ObservableObject {
    @Published var playerPositions = [GGBoardPosition]()
    @Published var boardPositions = [[GGBoardPosition]]()
    
    func start() {
        createBoard()
        deployUnits()
    }

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

    func deployUnits() {
        playerPositions = GameViewModel.createStandardDeployment()
        
        // assign the positions to the board
        for row in 0..<GameViewModel.rows {
            let rowArray = boardPositions[row]

            switch row {
            // bottom 3 rows
            case 5,6,7:
                for column in 0..<GameViewModel.columns {
                    if let boardPosition = playerPositions.first(where: { $0.row+5 == row && $0.column == column}) {
                        rowArray[column].rank = boardPosition.rank
                    }
                }

            default:
                ()
            }
        }
    }
    
    func updatePlayerPositions() {
        playerPositions.removeAll()
        
        for row in 0..<GameViewModel.rows {
            for column in 0..<GameViewModel.columns {
                let boardPosition = boardPositions[row][column]
                
                if boardPosition.rank != nil {
                    // adjust the row to 0..2
                    boardPosition.row = row-5
                    playerPositions.append(GGBoardPosition(from: boardPosition))
                }
            }
        }
    }
}
