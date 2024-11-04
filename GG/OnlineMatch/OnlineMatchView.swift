//
//  OnlineMatchView.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI

struct OnlineMatchView: View {
    @Binding var homeScreenKey: HomeScreenKey?

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
            homeScreenKey = nil
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
    OnlineMatchView(homeScreenKey: .constant(nil))
}
