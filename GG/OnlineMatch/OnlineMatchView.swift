//
//  OnlineMatchView.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI

struct OnlineMatchView: View {
    @StateObject private var playerAuth: PlayerAuthModel =  PlayerAuthModel()
    @State private var isShowingPlayerView = false

    var body: some View {
        main()
            .fullScreenCover(isPresented: $isShowingPlayerView) {
                CreatePlayerView(playerAuth: playerAuth)
            }
    }

    func main() -> some View {
        VStack {
            Text("Online Match")
            
            if (!playerAuth.playerID.isEmpty) {
                VStack {
                    ProgressView(label: {
                        Text("Waiting for opponent...")
                    })
                    .onAppear {
                        getPlayer()
                    }
                    SignOutButton()
                        .buttonStyle(.bordered)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                }
            } else {
                SignInButton()
                    .buttonStyle(.bordered)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
            }

            HomeButton()
                .buttonStyle(.bordered)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GGConstants.menuViewBackgroundColor)
        .ignoresSafeArea()
    }
    
    fileprivate func SignInButton() -> Button<Text> {
        Button {
            playerAuth.signIn()
        } label: {
            Text("Sign In")
        }
    }
    
    fileprivate func SignOutButton() -> Button<Text> {
        Button {
            playerAuth.signOut()
        } label: {
            Text("Sign Out")
        }
    }
    
    fileprivate func HomeButton() -> Button<Text> {
        Button {
            ViewManager.shared.changeView(to: .home)
        } label: {
            Text("Home")
        }
    }
    
    func getPlayer() {
        Task {
            try await playerAuth.getPlayer()

            DispatchQueue.main.async {
                isShowingPlayerView = playerAuth.player == nil
            }
        }
    }
}

#Preview {
    OnlineMatchView()
}
