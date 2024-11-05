//
//  HomeView.swift
//  GG
//
//  Created by Vito Royeca on 10/28/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewManager = ViewManager.shared
    
    var body: some View {
        main()
    }

    @ViewBuilder
    private func main() -> some View {
        VStack(spacing: 50) {
            titleView()
            buttonsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GGConstants.menuViewBackgroundColor)
        .ignoresSafeArea()
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
            Button {
                viewManager.changeView(to: .play)
            } label: {
                Text(ViewKey.play.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .leaderboard)
            } label: {
                Text(ViewKey.leaderboard.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .settings)
            } label: {
                Text(ViewKey.settings.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .help)
            } label: {
                Text(ViewKey.help.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
}
