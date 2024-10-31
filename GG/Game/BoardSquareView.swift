//
//  BoardSquareView.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import SwiftUI

struct BoardSquareView: View {
    let boardPosition: GGBoardPosition?
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
                
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading, 2)
                    .padding(.trailing, 2)
            }
            
            if let action = action {
                let name = switch action {
                case .up:
                    "arrow.up.circle.dotted"
                case .left:
                    "arrow.left.circle.dotted"
                case .down:
                    "arrow.down.circle.dotted"
                case .right:
                    "arrow.right.circle.dotted"
                case .fight:
                    "figure.fencing.circle"
                }
                
                let updatedName = isLastAction ? name.replacingOccurrences(of: ".dotted", with: "") : name
                let actionColor: Color = isLastAction ? ((player?.isBottomPlayer ?? false) ? .white : .black) : .white
                
                Image(systemName: updatedName)
                    .resizable()
                    .foregroundStyle(actionColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width-10, height: height-10)
                
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    let boardPosition = GGBoardPosition(row: 0,
                                        column: 0,
                                        unit: GGUnit(rank: .flag))
    
    BoardSquareView(boardPosition: boardPosition,
                    revealUnit: true,
                    color: GGConstants.gameViewDefaultSquareColor,
                    width: 40,
                    height: 20)
}
