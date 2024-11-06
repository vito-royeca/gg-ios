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
                viewManager.changeView(to: .playView)
            } label: {
                Text(ViewKey.playView.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .leaderboardView)
            } label: {
                Text(ViewKey.leaderboardView.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .settingsView)
            } label: {
                Text(ViewKey.settingsView.description)
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            
            Button {
                viewManager.changeView(to: .helpView)
            } label: {
                Text(ViewKey.helpView.description)
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
