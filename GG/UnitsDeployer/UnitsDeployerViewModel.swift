//
//  UnitsDeployerViewModel.swift
//  GG
//
//  Created by Vito Royeca on 10/30/24.
//

import SwiftUI

class UnitsDeployerViewModel: ObservableObject {
    @Published var player = GGPlayer()
    @Published var boardPositions = [[BoardPosition]]()
    
    func createBoard() {
        boardPositions = [[BoardPosition]]()
        
        for row in 0..<GameViewModel.rows {
            var rowArray = [BoardPosition]()
            
            for column in 0..<GameViewModel.columns {
                let boardPosition = BoardPosition(row: row, column: column)
                rowArray.append(boardPosition)
            }
            boardPositions.append(rowArray)
        }
    }

    func mobilizePlayer() {
        player = GGPlayer()
        player.mobilize(homeRow: GameViewModel.rows - 1)

        let playerPositions = GameViewModel.createStandardDeployment(for: player)
        
        for row in 0..<GameViewModel.rows {
            let rowArray = boardPositions[row]

            switch row {
            // player 2
            case 5,6,7:
                for column in 0..<GameViewModel.columns {
                    for boardPosition in playerPositions[row-5] {
                        if boardPosition.column == column {
                            rowArray[column].player = boardPosition.player
                            rowArray[column].unit = boardPosition.unit
                        }
                    }
                }

            default:
                ()
            }
        }
    }
}
