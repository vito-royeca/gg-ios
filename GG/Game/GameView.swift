//
//  GAmeView.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: GameViewModel
    @State private var showingSurrender = false
    
    var body: some View {
        main()
            .onAppear {
                withAnimation {
                    viewModel.start()
                }
            }
    }
    
    @ViewBuilder
    private func main() -> some View {
        GeometryReader { reader in
            VStack(spacing: 30) {
                createSurrenderButton()
                
                createCasualtiesView(viewModel.player1Casualties,
                                     revealUnit: viewModel.gameType == .humanVsAI ? viewModel.isGameOver : true,
                                     isDark: true,
                                     width: reader.size.width,
                                     height: reader.size.height)

                ZStack {
                    createBoardView(width: reader.size.width, height: reader.size.height)
                    Text(viewModel.statusText)
                        .foregroundStyle(.red)
                        .font(.largeTitle)
                }
                
                createCasualtiesView(viewModel.player2Casualties,
                                     revealUnit: true,
                                     isDark: false,
                                     width: reader.size.width,
                                     height: reader.size.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GGConstants.gameViewBackgroundColor)
        }
    }
    
    @ViewBuilder
    private func createSurrenderButton() -> some View {
        HStack {
            Spacer()
            Button {
                if viewModel.isGameOver {
                    viewModel.quit()
                    dismiss()
                } else {
                    showingSurrender = true
                }
            } label: {
                Image(systemName: "flag.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
            }
            .frame(width: 80, height: 40)
            .alert(isPresented:$showingSurrender) {
                let titleText = switch viewModel.gameType {
                case .aiVsAI:
                    "Leave the battle?"
                case .humanVsAI:
                    "Surrender the battle?"
                case .humanVsHuman:
                    "Surrender the battle?"
                }

                return Alert(
                    title: Text(titleText),
                    primaryButton: .destructive(Text("Yes")) {
                        viewModel.quit()
                        dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding(.bottom, 20)
    }

    @ViewBuilder func createBoardView(width: CGFloat, height: CGFloat) -> some View {
        let squareWidth = width / CGFloat(GameViewModel.columns)
        let squareHeight = squareWidth

        Grid(alignment: .topLeading,
             horizontalSpacing: 1,
             verticalSpacing: 1) {
            ForEach(0..<GameViewModel.rows, id: \.self) { row in
                if row == 4 {
                    Divider()
                        .padding(1)
                }
                
                GridRow {
                    ForEach(0..<GameViewModel.columns, id: \.self) { column in
                        let boardPosition = viewModel.boardPositions.isEmpty ?
                            nil :
                            viewModel.boardPositions[row][column]
                        let revealUnit = viewModel.gameType == .aiVsAI ?
                            true :
                            ((boardPosition?.player?.isBottomPlayer ?? false) ? true : viewModel.isGameOver)
                        let color = GGConstants.gameViewDefaultSquareColor

                        BoardSquareView(boardPosition: boardPosition,
                                        revealUnit: revealUnit,
                                        color: color,
                                        width: squareWidth,
                                        height: squareHeight)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.doHumanMove(row: row, column: column)
                                }
                            }
                    }
                }

            }
        }
    }
    
    @ViewBuilder func createCasualtiesView(_ casualties: [[GGUnit]],
                                           revealUnit: Bool,
                                           isDark: Bool,
                                           width: CGFloat,
                                           height: CGFloat) -> some View {
        let squareWidth = width / CGFloat(GameViewModel.unitCount / 3)
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
                                    let name = revealUnit ? "\(unit.rank.iconName)-\(colorName)" : "blank-\(colorName)"
                                    
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
    let boardPosition: BoardPosition?
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
    GameView(viewModel: GameViewModel(gameType: .humanVsAI))
}
