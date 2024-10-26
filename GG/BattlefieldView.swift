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
//        NavigationView {
            GeometryReader { reader in
                VStack(spacing: 30) {
                    createCasualtiesView(game.player1Casualties,
                                         revealUnit: game.isGameOver,
                                         isDark: true,
                                         width: reader.size.width,
                                         height: reader.size.height)
                    ZStack {
                        createBoardView(width: reader.size.width, height: reader.size.height)
                        Text(game.statusText)
                            .foregroundStyle(.red)
                            .font(.largeTitle)
                    }
                    
                    createCasualtiesView(game.player2Casualties,
                                         revealUnit: true,
                                         isDark: false,
                                         width: reader.size.width,
                                         height: reader.size.height)
                    
                    Button {
                        withAnimation {
                            game.start()
                        }
                    } label: {
                        Text("New Game")
                    }
                    .disabled(!game.isGameOver)
                }
            }
//            .navigationBarItems(
//                trailing:
//                    Button {
//                        withAnimation {
//                            game.start()
//                        }
//                    } label: {
//                        Text("New Game")
//                    }
//            )
//        }
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
                        let move = boardPosition?.move
                        let isLastMove = boardPosition?.isLastMove ?? false
                        
                        BoardSquareView(player: player,
                                        unit: unit,
                                        move: move,
                                        isLastMove: isLastMove,
                                        revealUnit: (player?.isHuman ?? false) ? true : game.isGameOver,
                                        color: Color.gray,
                                        width: squareWidth,
                                        height: squareHeight)
                        .onTapGesture {
                            withAnimation {
                                game.doHumanMove(row: row, column: column)
                            }
                        }
                    }
                }

            }
        }
    }
    
    @ViewBuilder func createCasualtiesView(_ casualties: [[GGUnit]], revealUnit: Bool, isDark: Bool, width: CGFloat, height: CGFloat) -> some View {
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
                            
                            if casualties.count-1 >= row {
                                let array = casualties[row]
                                
                                if array.count-1 >= column {
                                    let unit = casualties[row][column]
                                    let colorName = isDark ? "black" : "white"
                                    let name = revealUnit ? "\(unit.iconName)-\(colorName)" : "blank-\(colorName)"
                                    
                                    Image(name)
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
    let move: GameMove?
    let isLastMove: Bool
    let revealUnit: Bool
    let color: Color
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            color
            
            if let unit = unit {
                let colorName = (player?.isHuman ?? false) ? "white" : "black"
                let name = revealUnit ? "\(unit.iconName)-\(colorName)" : "blank-\(colorName)"
                
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.leading, 2)
                    .padding(.trailing, 2)
            }
            
            if let move = move {
                let name = switch move {
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
                
                Image(systemName: isLastMove ? name.replacingOccurrences(of: ".dotted", with: "") : name)
                    .resizable()
                    .foregroundStyle(.white)
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
