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
    @Binding var homeScreenKey: HomeScreenKey?

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
                homeScreenKey = nil
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
            let titleText = switch viewModel.gameType {
            case .aiVsAI:
                "Leave the battle?"
            case .humanVsAI:
                "Surrender the battle?"
            case .online:
                "Surrender the battle?"
            }

            return Alert(
                title: Text(titleText),
                primaryButton: .destructive(Text("Yes")) {
                    viewModel.quit()
                    homeScreenKey = nil
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
                       viewModel: viewModel,
                       homeScreenKey: .constant(nil))
    }
}
