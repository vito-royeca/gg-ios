//
//  PlayMenuView.swift
//  GG
//
//  Created by Vito Royeca on 11/1/24.
//

import SwiftUI

struct PlayMenuView: View {
    @ObservedObject var viewManager = ViewManager.shared
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
                viewManager.changeView(to: .playAiVsAi)
            } label: {
                Text(ViewKey.playAiVsAi.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .playHumanVsAi)
            } label: {
                Text(ViewKey.playHumanVsAi.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .playOnline)
            } label: {
                Text(ViewKey.playOnline.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .home)
            } label: {
                Text(ViewKey.home.description)
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
