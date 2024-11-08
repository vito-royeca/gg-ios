//
//  OnlineMatchView.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI

struct OnlineMatchView: View {
    @ObservedObject var playerManager = PlayerManager.shared
    @ObservedObject var viewModel = OnlineMatchViewModel()

    var positions: [GGBoardPosition]?
    
    @State private var isShowingCreatePlayer = false

    var body: some View {
        main()
            .onAppear {
                checkStatus()
            }
            .fullScreenCover(isPresented: $isShowingCreatePlayer) {
                CreatePlayerView()
            }
            .onChange(of: viewModel.game) {
                startGame()
            }
    }

    func main() -> some View {
        VStack {
            Text("Online Match")
            
            if playerManager.isLoggedIn {
                VStack {
                    if positions != nil {
                        ProgressView(label: {
                            Text("Waiting for opponent...")
                        })
                        .onAppear {
                            joinGame()
                        }
                    } else {
                        DeployButton()
                            .buttonStyle(.bordered)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                    }
                    
//                    SignOutButton()
//                        .buttonStyle(.bordered)
//                        .frame(height: 40)
//                        .frame(maxWidth: .infinity)
                }
            } else {
                SignInButton()
                    .buttonStyle(.bordered)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
            }

            CancelButton()
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
            Task {
                try await playerManager.signIn()
            }
        } label: {
            Text("Sign In")
        }
    }
    
    fileprivate func SignOutButton() -> Button<Text> {
        Button {
            Task {
                try await playerManager.signOut()
            }
        } label: {
            Text("Sign Out")
        }
    }
    
    fileprivate func DeployButton() -> Button<Text> {
        Button {
            Task {
                ViewManager.shared.changeView(to: .unitsDeployerView(.humanVsHuman))
            }
        } label: {
            Text("Deploy Units")
        }
    }

    fileprivate func CancelButton() -> Button<Text> {
        Button {
            viewModel.quitGame()
            ViewManager.shared.changeView(to: .homeView)
        } label: {
            Text("Cancel")
        }
    }
    
    func checkStatus() {
        Task {
            try await playerManager.checkStatus()
            if playerManager.isLoggedIn {
                isShowingCreatePlayer = playerManager.player == nil
            }
            
        }
    }
    
    func joinGame() {
        guard let player = playerManager.player,
              let positions else {
            return
        }
        
        Task {
            do {
                try await viewModel.joinGame(playerID: player.id, positions: positions)
            } catch {
                print(error)
            }
        }
    }
    
    func startGame() {
        guard viewModel.game?.player1ID != nil,
              viewModel.game?.player2ID != nil,
              let player1Positions = viewModel.game?.player1Positions,
              let player2Positions = viewModel.game?.player2Positions else {
            return
        }
        
        Task {
            do {
                try await viewModel.getPlayers()
                guard let player1 = viewModel.player1,
                      let player2 = viewModel.player2 else {
                    return
                }
                
                let enemyPlayer = player1.isLoggedInUser ? player1 : player2
                let myPlayer = player1.isLoggedInUser ? player2 : player1
                let enemyPositions = player1.isLoggedInUser ? player1Positions : player2Positions
                let myPositions = player1.isLoggedInUser ? player2Positions : player1Positions
                
                ViewManager.shared.changeView(to: .humanVsHumanGame(enemyPlayer,
                                                                    myPlayer,
                                                                    enemyPositions,
                                                                    myPositions))
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    OnlineMatchView(positions: nil)
}
