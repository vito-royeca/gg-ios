//
//  UnitsDeployerView.swift
//  GG
//
//  Created by Vito Royeca on 10/30/24.
//

import SwiftUI

struct UnitsDeployerView: View {
    @ObservedObject var viewModel: UnitsDeployerViewModel

    @State private var draggedPosition: GGBoardPosition?
    @State private var isShowingGame = false

    var body: some View {
        main().onAppear {
            viewModel.createBoard()
            viewModel.mobilizePlayer()
        }
        
        .fullScreenCover(isPresented: $isShowingGame) {
            GameView(viewModel: GameViewModel(gameType: .humanVsAI,
                                              player2Positions: viewModel.playerPositions))
        }
    }
    
    @ViewBuilder
    private func main() -> some View {
        GeometryReader { reader in
            VStack(spacing: 30) {
                Text("Drag and drop your units in the game board.")
                    .font(.title)
                    .foregroundStyle(.white)
                
                createBoardView(width: reader.size.width, height: reader.size.height)

                createButtonsView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GGConstants.gameViewBackgroundColor)
        }
    }
    
    @ViewBuilder
    private func createButtonsView() -> some View {
        HStack {
            Button {
                ViewManager.shared.changeView(to: .home)
            } label: {
                Text("Cancel")
            }
            .buttonStyle(.borderedProminent)
            .frame(height: 40)
            
            Button {
                viewModel.updatePlayerPositions()
                isShowingGame = true
            } label: {
                Text("Submit")
            }
            .buttonStyle(.borderedProminent)
            .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
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
                let color = switch row {
                case 5,6,7:
                    GGConstants.gameViewAllowedSquareColor
                default:
                    GGConstants.gameViewBannedSquareColor
                }

                GridRow {
                    ForEach(0..<GameViewModel.columns, id: \.self) { column in
                        let boardPosition = viewModel.boardPositions.isEmpty ?
                            GGBoardPosition(row: 0, column: 0) :
                            viewModel.boardPositions[row][column]
                        let delegate = UnitsDeployerDropViewDelegate(boardPosition: boardPosition,
                                                                     boardPositions: $viewModel.boardPositions,
                                                                     draggedPosition: $draggedPosition)
                        
                        BoardSquareView(boardPosition: boardPosition,
                                        draggedPosition: $draggedPosition,
                                        dropDelegate: delegate,
                                        revealUnit: true,
                                        color: color,
                                        width: squareWidth,
                                        height: squareHeight)
                    }
                }

            }
        }
    }
}

#Preview {
    UnitsDeployerView(viewModel: UnitsDeployerViewModel())
}
