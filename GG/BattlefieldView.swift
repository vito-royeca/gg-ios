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
        NavigationView {
            GeometryReader { reader in
                VStack(spacing: 20) {
                    Text(game.statusText)
                    createBoardView(width: reader.size.width, height: reader.size.height)
                    Text("Casualties")
                    createCasualtiesView(width: reader.size.width, height: reader.size.height)
                }
            }
            .navigationBarItems(
                trailing:
                    Button {
                        withAnimation {
                            game.start()
                        }
                    } label: {
                        Text("New Game")
                    }
            )
        }
    }
    
    @ViewBuilder func createBoardView(width: CGFloat, height: CGFloat) -> some View {
        let squareWidth = width / CGFloat(Game.columns)
        let squareHeight = squareWidth

        Grid(alignment: .topLeading,
             horizontalSpacing: 1,
             verticalSpacing: 1) {
            ForEach(0..<Game.rows, id: \.self) { row in
                if row == 4 {
                    Divider()
                        .padding(1)
                }
                
                GridRow {
                    ForEach(0..<Game.columns, id: \.self) { column in
                        let boardPosition = game.boardPositions.isEmpty ? nil : game.boardPositions[row][column]
                        let player =  boardPosition?.player
                        let unit =  boardPosition?.unit
                        let possibleMove = boardPosition?.possibleMove
                        
                        BoardSquareView(player: player,
                                        unit: unit,
                                        possibleMove: possibleMove,
                                        revealUnit: game.isGameOver,
                                        color: Color.gray,
                                        width: squareWidth,
                                        height: squareHeight)
                        .onTapGesture {
                            withAnimation {
                                game.handleTap(row: row, column: column)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    @ViewBuilder func createCasualtiesView(width: CGFloat, height: CGFloat) -> some View {
        
        let squareWidth = width / CGFloat(Game.unitCount / 3)
        let squareHeight = squareWidth

        Grid(alignment: .topLeading,
             horizontalSpacing: 1,
             verticalSpacing: 1) {
            
            ForEach(0..<3) { row in
                GridRow {
                    ForEach(0..<7) { column in
                        ZStack {
                            Color.gray
                            
                            if game.playerCasualties.count-1 >= row {
                                let array = game.playerCasualties[row]
                                
                                if array.count-1 >= column {
                                    let unit = game.playerCasualties[row][column]

                                    Image("\(unit.iconName)-white")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(2)
                                }
                            }

                        }
                        .frame(width: squareWidth, height: squareHeight/2)
                    }
                }
            }
        }
        
    }
}

struct BoardSquareView: View {
    let player: GGPlayer?
    let unit: GGUnit?
    let possibleMove: GameMove?
    let revealUnit: Bool
    let color: Color
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            color
            
            if let player = player,
                let unit = unit {
                if player.isHuman {
                    Image("\(unit.iconName)-white")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.leading, 2)
                        .padding(.trailing, 2)
                } else {
                    let name = revealUnit ? "\(unit.iconName)-black" : "blank-white"

                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.leading, 2)
                        .padding(.trailing, 2)
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
