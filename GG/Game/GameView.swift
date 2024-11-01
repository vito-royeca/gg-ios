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
            VStack(spacing: 20) {
                AvatarView(geometry: reader)
                
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

                ZStack {
                    AvatarView(geometry: reader)
                    HStack {
                        Spacer()
                        createSurrenderButton()
                            .padding(.trailing, 20)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GGConstants.gameViewBackgroundColor)
        }
    }
    
    @ViewBuilder
    private func createSurrenderButton() -> some View {
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
        .frame(width: 20, height: 20)
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
                            GGBoardPosition(row: 0, column: 0) :
                            viewModel.boardPositions[row][column]
                        let revealUnit = viewModel.gameType == .aiVsAI ?
                            true :
                            ((boardPosition.player?.isBottomPlayer ?? false) ? true : viewModel.isGameOver)
                        let color = GGConstants.gameViewBoardSquareColor

                        BoardSquareView(boardPosition: boardPosition,
                                        draggedPosition: .constant(nil),
                                        dropDelegate: nil,
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
                            GGConstants.gameViewCasualtySquareColor
                            
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

#Preview {
    GameView(viewModel: GameViewModel(gameType: .humanVsAI))
}
