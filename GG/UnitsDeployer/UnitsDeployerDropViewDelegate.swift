//
//  UnitsDeployerDropViewDelegate.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import SwiftUI

struct UnitsDeployerDropViewDelegate: DropDelegate {
    let boardPosition: GGBoardPosition
    @Binding var boardPositions: [[GGBoardPosition]]
    @Binding var draggedPosition: GGBoardPosition?
    
    func validateDrop(info: DropInfo) -> Bool {
        return boardPosition.row >= 5
    }

    func performDrop(info: DropInfo) -> Bool {
        swapPositions()
        draggedPosition = nil
        return true
    }
    
    func swapPositions() {
        guard let draggedPosition = draggedPosition,
              draggedPosition != boardPosition else {
            return
        }
        
        
        let toPosition = GGBoardPosition(row: boardPosition.row,
                                         column: boardPosition.column,
                                         player: draggedPosition.player,
                                         rank: draggedPosition.rank)
        let fromPosition = GGBoardPosition(row: draggedPosition.row,
                                           column: draggedPosition.column,
                                           player: boardPosition.player,
                                           rank: boardPosition.rank)

        withAnimation {
            boardPositions[boardPosition.row][boardPosition.column] = toPosition
            boardPositions[draggedPosition.row][draggedPosition.column] = fromPosition
        }
    }
}
