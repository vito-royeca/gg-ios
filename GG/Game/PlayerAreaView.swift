//
//  PlayerAreaView.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI

struct PlayerAreaView: View {
    let proxy: GeometryProxy
    let player: FPlayer
    @ObservedObject var viewModel: GameViewModel
    @ObservedObject var onlineModel: OnlineMatchViewModel
    
    @State private var isShowingSurrender = false

    var body: some View {
        let width = proxy.size.width / CGFloat(GameViewModel.columns)
        let height = width
        let username = player.isLoggedInUser ? "You" : player.username
        let color:Color = player.isLoggedInUser ? .white : .black
        let turnText = onlineModel.game?.activePlayerID == player.id ? "Your Turn" : "Opponent's Turn"

        HStack {
            VStack {
                AvatarView(player: player,
                           width: width,
                           height: height)
                Text(username)
                    .font(.headline)
            }
            Spacer()
            if player.isLoggedInUser {
                Text(turnText)
                    .font(.headline)
            } else {
                EmptyView()
            }
            Spacer()
            if player.isLoggedInUser {
                createSurrenderButton()
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
                isShowingSurrender = true
            }
        } label: {
            Image(systemName: viewModel.isGameOver ? "door.left.hand.open" : "flag.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        }
        .frame(width: 20, height: 20)
        .alert(isPresented:$isShowingSurrender) {
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
    GeometryReader { proxy in
        PlayerAreaView(proxy: proxy,
                       player: FPlayer.emptyPlayer,
                       viewModel: GameViewModel(gameType: .aiVsAI),
                       onlineModel: OnlineMatchViewModel())
    }
}
