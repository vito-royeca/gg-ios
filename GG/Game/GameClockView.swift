//
//  GameClockView.swift
//  GG
//
//  Created by Vito Royeca on 12/4/24.
//

import SwiftUI

struct GameClockView: View {
    let player: GGPlayer
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        HStack {
            Image(systemName: "hourglass")
                .foregroundStyle(player.avatarColor)
            
            ProgressView(viewModel.turnText,
                         value: viewModel.turnProgress,
                         total: GameViewModel.turnLimit)
                .tint(player.avatarColor)
                .foregroundStyle(player.avatarColor)
        }
        .opacity(viewModel.turnProgress > 0 ? 1 : 0)
    }
}

#Preview {
    GameClockView(player: GGPlayer(displayName: "You",
                                   homeRow: GameViewModel.rows - 1),
                  viewModel: GameViewModel(gameType: .aiVsAI))
}
