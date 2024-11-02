//
//  HomeView.swift
//  GG
//
//  Created by Vito Royeca on 10/28/24.
//

import SwiftUI

enum HomeScreenKey: CaseIterable, Identifiable {
    case play, leaderboard, settings, help
    
    var id: Self {
        return self
    }
    
    var description: String {
        switch self {
        case .play:
            "Play"
        case .leaderboard:
            "Leaderboard"
        case .settings:
            "Settings"
        case .help:
            "Help"
        }
    }
}

struct HomeView: View {
    @State private var homeScreenKey: HomeScreenKey?
    
    var body: some View {
        main()
            .fullScreenCover(item: $homeScreenKey) { key in
                switch key {
                case .play:
                    PlayMenuView(homeScreenKey: $homeScreenKey)
                case .leaderboard:
                    LeaderboardView(homeScreenKey: $homeScreenKey)
                case .settings:
                    SettingsView(homeScreenKey: $homeScreenKey)
                case .help:
                    HelpView(homeScreenKey: $homeScreenKey)
                }
            }
    }

    @ViewBuilder
    private func main() -> some View {
        VStack(spacing: 50) {
            titleView()
            buttonsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(red: 0.91, green: 0.89, blue: 0.90))
    }

    @ViewBuilder
    private func titleView() -> some View {
        VStack(spacing: 20) {
            Text("Salpakan")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text("A Game of the Generals")
                .font(.headline)
                .fontWeight(.semibold)
        }
        .foregroundColor(.indigo)
        .padding(.top, 50)
    }
    
    @ViewBuilder
    private func buttonsView() -> some View {
        VStack(spacing: 15) {
            ForEach(HomeScreenKey.allCases, id: \.self) { key in
                Button {
                    homeScreenKey = key
                } label: {
                    Text(key.description)
                }
                .buttonStyle(.bordered)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 50)
    }
}

#Preview {
    HomeView()
}
