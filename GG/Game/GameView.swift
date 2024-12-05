//
//  GAmeView.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import SwiftUI

struct GameView: View {

    @ObservedObject private var viewModel: GameViewModel
    
    private var gameType: GameType
    
    init(gameType: GameType,
         gameID: String? = nil,
         player1: FPlayer? = nil,
         player2: FPlayer? = nil,
         player1Positions: [GGBoardPosition]? = nil,
         player2Positions: [GGBoardPosition]? = nil) {
        
        self.gameType = gameType
        viewModel = .init(gameType: gameType,
                          gameID: gameID,
                          player1: player1,
                          player2: player2,
                          player1Positions: player1Positions,
                          player2Positions: player2Positions)
    }
    
    var body: some View {
        createMainView()
            .onAppear {
                withAnimation {
                    viewModel.start()
                }
            }
    }
}

extension GameView {

    @ViewBuilder
    func createMainView() -> some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 20) {
                    createStatusView(for: viewModel.player1,
                                     casualties: viewModel.player1Casualties,
                                     proxy: proxy)
                    
                    ZStack {
                        createBoardView(proxy: proxy)
                        Text(viewModel.statusText)
                            .foregroundStyle(.red)
                            .font(.largeTitle)
                    }
                    
                    createStatusView(for: viewModel.player2,
                                     casualties: viewModel.player2Casualties,
                                     proxy: proxy)
                }
                
                createPlayerAreaView(proxy: proxy)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GGConstants.gameViewBackgroundColor)
        }
    }
}

extension GameView {

    @ViewBuilder
    func createStatusView(for player: GGPlayer,
                          casualties: [[GGRank]],
                          proxy: GeometryProxy) -> some View {
        if viewModel.isGameOver {
            createCasualtiesView(player: player,
                                 casualties: casualties,
                                 revealUnit: gameType == .aiVsAI ? true : viewModel.isGameOver,
                                 proxy: proxy)
        } else {
            switch gameType {
            case .aiVsAI:
                EmptyView()
            case .humanVsAI:
                if player.isBottomPlayer {
                    GameClockView(player: player,
                                  viewModel: viewModel)
                        .padding()
                } else {
                    EmptyView()
                }
            case .humanVsHuman:
                GameClockView(player: player,
                              viewModel: viewModel)
                    .padding()
            }
        }
    }
}

extension GameView {

    @ViewBuilder
    func createBoardView(proxy: GeometryProxy) -> some View {
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
                        let revealUnit = gameType == .aiVsAI ?
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
}

extension GameView {
    
    @ViewBuilder
    func createCasualtiesView(player: GGPlayer,
                              casualties: [[GGRank]],
                              revealUnit: Bool,
                              proxy: GeometryProxy) -> some View {
        let squareWidth = proxy.size.width / CGFloat(GameViewModel.unitCount / 3)
        let squareHeight = squareWidth
        
        Grid(alignment: .topLeading,
             horizontalSpacing: 1,
             verticalSpacing: 1) {
            
            ForEach(0..<3) { row in
                GridRow {
                    ForEach(0..<7) { column in
                        let rank: GGRank? = (casualties.count-1 >= row && casualties[row].count-1 >= column) ?
                            casualties[row][column] :
                            nil
                        let boardPosition = GGBoardPosition(row: row,
                                                            column: column,
                                                            player: player,
                                                            rank: rank)
                        
                        BoardSquareView(boardPosition: boardPosition,
                                        draggedPosition: .constant(nil),
                                        dropDelegate: nil,
                                        revealUnit: revealUnit,
                                        color: GGConstants.gameViewCasualtySquareColor,
                                        width: squareWidth,
                                        height: squareHeight/2)
                    }
                }
            }
        }
    }
}

extension GameView {

    @ViewBuilder
    func createPlayerAreaView(proxy: GeometryProxy) -> some View {
        VStack {
            
            PlayerAreaView(proxy: proxy,
                           player: viewModel.player1,
                           showActionButton: false,
                           viewModel: viewModel)
            Spacer()
            PlayerAreaView(proxy: proxy,
                           player: viewModel.player2,
                           showActionButton: true,
                           viewModel: viewModel)
        }
        .padding()
    }
}

#Preview {
    GameView(gameType: .humanVsAI,
             player2Positions: GameViewModel.createStandardDeployment())
}
