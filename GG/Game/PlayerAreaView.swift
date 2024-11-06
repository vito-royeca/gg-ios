//
//  PlayerAreaView.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI

struct PlayerAreaView: View {
    let proxy: GeometryProxy
    let player: GGPlayer
    @ObservedObject var viewModel: GameViewModel

    @State private var showingSurrender = false

    var body: some View {
        let width = proxy.size.width / CGFloat(GameViewModel.columns)
        let height = width
        
        ZStack {
            AvatarView(player: player,
                       width: width,
                       height: height)
            if player.isBottomPlayer {
                HStack {
                    Spacer()
                    createSurrenderButton()
                        .padding(.trailing, 20)
                }
            }
        }
    }
    
    @ViewBuilder
    private func createSurrenderButton() -> some View {
        Button {
            if viewModel.isGameOver {
                viewModel.quit()
                ViewManager.shared.changeView(to: .homeView)
            } else {
                showingSurrender = true
            }
        } label: {
            Image(systemName: viewModel.isGameOver ? "door.left.hand.open" : "flag.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        }
        .frame(width: 20, height: 20)
        .alert(isPresented:$showingSurrender) {
            let titleText = "Leave the battle?"

            return Alert(
                title: Text(titleText),
                message: Text("You will lower you ranking if you leave the battle."),
                primaryButton: .destructive(Text("Yes")) {
                    viewModel.quit()
                    ViewManager.shared.changeView(to: .homeView)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    let viewModel = GameViewModel(gameType: .aiVsAI)
    
    GeometryReader { proxy in
        PlayerAreaView(proxy: proxy,
                       player: viewModel.player2,
                       viewModel: viewModel)
    }
}
