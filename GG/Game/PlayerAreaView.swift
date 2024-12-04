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
    let showActionButton: Bool
    @ObservedObject var viewModel: GameViewModel
    
    @State private var isShowingSurrender = false

    var body: some View {
        let width = proxy.size.width / CGFloat(GameViewModel.columns)
        let height = width

        HStack {
            HStack {
                AvatarView(player: player,
                           width: width,
                           height: height)
                Text(player.displayName)
                    .font(.headline)
                    .foregroundStyle(player.avatarColor)
            }

            Spacer()

            Text(viewModel.turnText)
                .font(.headline)

            Spacer()

            if showActionButton {
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
            Image(systemName: viewModel.isGameOver ? "xmark.circle.fill" : "flag.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        }
        .frame(width: 40, height: 40)
        .alert(isPresented:$isShowingSurrender) {
            let titleText = Text("Leave the battle?")
            let messageText = viewModel.gameType == .humanVsHuman ? Text("You will lower you ranking if you leave the battle.") : nil
            
            return Alert(
                title: titleText,
                message: messageText,
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
                       player: GGPlayer(displayName: "You",
                                        homeRow: GameViewModel.rows - 1),
                       showActionButton: true,
                       viewModel: GameViewModel(gameType: .aiVsAI))
    }
}
