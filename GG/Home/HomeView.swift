//
//  HomeView.swift
//  GG
//
//  Created by Vito Royeca on 10/28/24.
//

import SwiftUI

struct HomeView: View {
    @State private var gameType: GameType?
    
    var body: some View {
        main()
            .fullScreenCover(item: $gameType) { gameType in
                switch gameType {
                case .aiVsAI:
                    GameView(viewModel: GameViewModel(gameType: gameType))
                case .humanVsAI:
                    UnitsDeployerView(viewModel: UnitsDeployerViewModel())
                case .humanVsHuman:
                    Text("Coming soon!")
                }
            }
    }

    @ViewBuilder
    private func main() -> some View {
        VStack(spacing: 50) {
            titleView()
            buttonView()
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
    private func buttonView() -> some View {
        VStack(spacing: 15) {
            ForEach(GameType.allCases, id: \.self) { type in
                Button {
                    self.gameType = type
                } label: {
                    Text(type.name)
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
