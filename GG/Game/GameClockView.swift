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

    private let timer = Timer.publish(every: GameViewModel.turnTick,
                                      on: .main,
                                      in: .common).autoconnect()
    
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
        .onReceive(timer) { time in
            if viewModel.turnProgress > 0 {
                var tempValue = viewModel.turnProgress - GameViewModel.turnTick
                if tempValue < 0 {
                    tempValue = 0
                }
                viewModel.turnProgress = tempValue
            } else {
                viewModel.endTurn()
            }
        }
    }
}

#Preview {
    GameClockView(player: GGPlayer(displayName: "You",
                                   homeRow: GameViewModel.rows - 1),
                  viewModel: GameViewModel(gameType: .aiVsAI))
}
