//
//  BattlefieldView.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import SwiftUI

struct BattlefieldView: View {
    @ObservedObject var game = Game()
    
    var body: some View {
        VStack {
            boardView
            Button {
                game.setup()
            } label: {
                Text("New Game")
            }
        }
    }
    
    var boardView: some View {
        GeometryReader { reader in
            let width = reader.size.width / CGFloat(Game.columns)
            let height = width

            if game.boardPositions.isEmpty {
                Text("Create new game")
            } else {
                withAnimation {
                    Grid(alignment: .topLeading,
                         horizontalSpacing: 1,
                         verticalSpacing: 1) {
                        ForEach(0..<Game.rows, id: \.self) { row in
                            let color:Color = switch row {
                            case 0,1,2:
                                    .gray
                            case 5,6,7:
                                    .gray
                            default:
                                    .green
                            }
                            
                            GridRow {
                                ForEach(0..<Game.columns, id: \.self) { column in
                                    let boardPosition = game.boardPositions[row][column]
                                    let player =  boardPosition.player
                                    let unit =  boardPosition.unit
                                    let possibleMove = boardPosition.possibleMove
                                    
                                    BoardSquareView(player: player,
                                                    unit: unit,
                                                    color: color,
                                                    width: width,
                                                    height: height,
                                                    possibleMove: possibleMove)
                                    .onTapGesture {
                                        game.handleTap(row: row, column: column)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
}

struct BoardSquareView: View {
    let player: Player?
    let unit: GGUnit?
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let possibleMove: GameMove?

    var body: some View {
        ZStack {
            color
            
            if let player = player,
                let unit = unit {
                if player.isHuman {
                    Image("\(unit.iconName)-white")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("blank-white")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            if let possibleMove = possibleMove {
                let name = switch possibleMove {
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
                
                Image(systemName: name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width-10, height: height-10)
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    BattlefieldView()
}
