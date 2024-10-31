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
    @Published var selectedBoardPosition: BoardPosition?
    
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
    
    func doMove(row: Int, column: Int) {
        let boardPosition = boardPositions[row][column]

        guard let selectedBoardPosition = selectedBoardPosition else {
            self.selectedBoardPosition = boardPositions[row][column]
            return
        }

        // same position selected, deselect
        if (selectedBoardPosition.row == boardPosition.row &&
            selectedBoardPosition.column == boardPosition.column) {
            self.selectedBoardPosition = nil
            return
        }

        if boardPosition.player != nil &&
           boardPosition.unit != nil {

            guard boardPosition.action != nil else {
                self.selectedBoardPosition = boardPositions[row][column]
                return
            }
        } else {
            guard boardPosition.action != nil else {
                self.selectedBoardPosition = nil
                return
            }
        }
        
        execute(move: GGMove(fromPosition: selectedBoardPosition,
                             toPosition: boardPosition))
        self.selectedBoardPosition = nil
    }
    
    func execute(move: GGMove) {
        let newPosition = BoardPosition(row: move.toPosition.row,
                                        column: move.toPosition.column,
                                        player: move.fromPosition.player,
                                        unit: move.fromPosition.unit)
        let emptyPosition = BoardPosition(row: move.fromPosition.row,
                                          column: move.fromPosition.column,
                                          player: move.fromPosition.player)
        
        boardPositions[move.fromPosition.row][move.fromPosition.column] = emptyPosition
        boardPositions[move.toPosition.row][move.toPosition.column] = newPosition
    }
}
