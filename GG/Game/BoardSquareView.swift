//
//  BoardSquareView.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import SwiftUI

struct BoardSquareView: View {
    let boardPosition: GGBoardPosition?
    @Binding var draggedPosition: GGBoardPosition?
    var dropDelegate: DropDelegate?
    let revealUnit: Bool
    let color: Color
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        let player =  boardPosition?.player
        let unit =  boardPosition?.unit
        let action = boardPosition?.action
        let isLastAction = boardPosition?.isLastAction ?? false

        ZStack {
            color
            
            if let unit = unit {
                let colorName = (player?.isBottomPlayer ?? false) ? "white" : "black"
                let name = revealUnit ? "\(unit.rank.iconName)-\(colorName)" : "blank-\(colorName)"
                
                createUnitView(iconName: name,
                               draggedPosition: draggedPosition,
                               dropDelegate: dropDelegate)
            }
            
            if let action = action {
                let name = isLastAction ? action.lastIconName : action.possibleIconName
                let actionColor: Color = isLastAction ? ((player?.isBottomPlayer ?? false) ? .white : .black) : .white
                
                Image(systemName: name)
                    .resizable()
                    .foregroundStyle(actionColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width-10, height: height-10)
                
            }
        }
        .frame(width: width, height: height)
    }
    
    @ViewBuilder func createUnitView(iconName: String,
                                     draggedPosition: GGBoardPosition?,
                                     dropDelegate: DropDelegate?) -> some View {
        if let dropDelegate = dropDelegate {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.leading, 2)
                .padding(.trailing, 2)
                .onDrag {
                    self.draggedPosition = boardPosition
                    return NSItemProvider()
                }
                .onDrop(of: [.boardPosition],
                        delegate: dropDelegate)
        } else {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.leading, 2)
                .padding(.trailing, 2)
        }
    }
    
}

#Preview {
    let boardPosition = GGBoardPosition(row: 0,
                                        column: 0,
                                        unit: GGUnit(rank: .flag))
    
    BoardSquareView(boardPosition: boardPosition,
                    draggedPosition: .constant(nil),
                    dropDelegate: nil,
                    revealUnit: true,
                    color: GGConstants.gameViewBoardSquareColor,
                    width: 40,
                    height: 20)
}
