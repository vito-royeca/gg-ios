//
//  PlayMenuView.swift
//  GG
//
//  Created by Vito Royeca on 11/1/24.
//

import SwiftUI

struct PlayMenuView: View {
    @State private var path: [GameType] = []

    var body: some View {
        main()
    }

    @ViewBuilder
    private func main() -> some View {
        VStack(spacing: 50) {
            buttonsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GGConstants.menuViewBackgroundColor)
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func buttonsView() -> some View {
        VStack(spacing: 15) {
            Button {
                ViewManager.shared.changeView(to: .aiVsAiGame)
            } label: {
                Text(ViewKey.aiVsAiGame.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                ViewManager.shared.changeView(to: .unitsDeployerView(.humanVsAI))
            } label: {
                Text(ViewKey.humanVsAiGame([]).description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                ViewManager.shared.changeView(to: .onlineView(nil))
            } label: {
                Text(ViewKey.onlineView(nil).description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                ViewManager.shared.changeView(to: .homeView)
            } label: {
                Text(ViewKey.homeView.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    PlayMenuView()
}
