//
//  PlayMenuView.swift
//  GG
//
//  Created by Vito Royeca on 11/1/24.
//

import SwiftUI

struct PlayMenuView: View {
    @Binding var homeScreenKey: HomeScreenKey?
    @State private var gameType: GameType?

    var body: some View {
        main()
            .fullScreenCover(item: $gameType) { gameType in
                switch gameType {
                case .aiVsAI:
                    GameView(viewModel: GameViewModel(gameType: gameType),
                             homeScreenKey: $homeScreenKey)
                case .humanVsAI:
                    UnitsDeployerView(viewModel: UnitsDeployerViewModel(),
                                      homeScreenKey: $homeScreenKey)
                case .humanVsHuman:
                    Text("Coming soon!")
                }
            }
    }
    
    @ViewBuilder
    private func main() -> some View {
        VStack(spacing: 50) {
            buttonView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(red: 0.91, green: 0.89, blue: 0.90))
    }

    @ViewBuilder
    private func buttonView() -> some View {
        VStack(spacing: 15) {
            ForEach(GameType.allCases, id: \.self) { gameType in
                Button {
                    self.gameType = gameType
                } label: {
                    Text(gameType.name)
                }
                .buttonStyle(.bordered)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
            }
            Button {
                homeScreenKey = nil
            } label: {
                Text("Home")
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 50)
    }
}

#Preview {
    PlayMenuView(homeScreenKey: .constant(nil))
}
