//
//  GAmeView.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel

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
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 20) {
                    createCasualtiesView(viewModel.player1Casualties,
                                         revealUnit: viewModel.gameType == .humanVsAI ? viewModel.isGameOver : true,
                                         isDark: true,
                                         proxy: proxy)

                    ZStack {
                        createBoardView(proxy: proxy)
                        Text(viewModel.statusText)
                            .foregroundStyle(.red)
                            .font(.largeTitle)
                    }
                    
                    createCasualtiesView(viewModel.player2Casualties,
                                         revealUnit: true,
                                         isDark: false,
                                         proxy: proxy)

                    
                }

                VStack {
                    PlayerAreaView(proxy: proxy,
                                   player: viewModel.player1,
                                   viewModel: viewModel)
                    Spacer()
                    PlayerAreaView(proxy: proxy,
                                   player: viewModel.player2,
                                   viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GGConstants.gameViewBackgroundColor)
        }
    }
    
    @ViewBuilder func createBoardView(proxy: GeometryProxy) -> some View {
        let squareWidth = proxy.size.width / CGFloat(GameViewModel.columns)
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
    
    @ViewBuilder func createCasualtiesView(_ casualties: [[GGRank]],
                                           revealUnit: Bool,
                                           isDark: Bool,
                                           proxy: GeometryProxy) -> some View {
        let squareWidth = proxy.size.width / CGFloat(GameViewModel.unitCount / 3)
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
                                    let rank = casualties[row][column]
                                    let colorName = isDark ? "black" : "white"
                                    let name = revealUnit ? "\(rank.iconName)-\(colorName)" : "blank-\(colorName)"
                                    
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
