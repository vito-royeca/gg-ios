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
    
    func dropEntered(info: DropInfo) {
        // Triggered when an object enters the view.
        swapPositions()
    }
    
    func dropExited(info: DropInfo) {
        // Triggered when an object exits the view.
//        swapPositions()
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        // Triggered when an object moves within the view.
        return DropProposal(operation: .move)
    }

    func validateDrop(info: DropInfo) -> Bool {
        // Determines whether to accept or reject the drop.
        return true
    }

    func performDrop(info: DropInfo) -> Bool {
        // Handles the drop when the user drops an object onto the view.
//        draggedPosition = nil
        guard info.hasItemsConforming(to: [.boardPosition]) else {
            return false
        }
        
        return true
    }
    
    func swapPositions() {
        guard let draggedPosition = draggedPosition,
              draggedPosition != boardPosition,
//              (draggedPosition.row != boardPosition.row && draggedPosition.column != boardPosition.column),
              boardPosition.row >= 5 else {
            return
        }
        print("target: \(boardPosition.unit?.rank ?? .flag)@(\(boardPosition.row),\(boardPosition.column))") // new
        print("dragged: \(draggedPosition.unit?.rank ?? .flag)@(\(draggedPosition.row),\(draggedPosition.column))") // old
        print("------")
        
        let newPosition = GGBoardPosition(row: boardPosition.row,
                                          column: boardPosition.column,
                                          player: draggedPosition.player,
                                          unit: draggedPosition.unit)
        let oldPosition = GGBoardPosition(row: draggedPosition.row,
                                          column: draggedPosition.column,
                                          player: boardPosition.player,
                                          unit: boardPosition.unit)
        
//        let newPosition = GGBoardPosition(from: boardPosition)
//        let oldPosition = GGBoardPosition(from: draggedPosition)

        withAnimation {
            boardPositions[boardPosition.row][boardPosition.column] = newPosition
            boardPositions[draggedPosition.row][draggedPosition.column] = oldPosition
            
        }
    }
}
