//
//  GGApp.swift
//  GG
//
//  Created by Vito Royeca on 10/22/24.
//

import SwiftUI
import SwiftData
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct GGApp: App {
    @ObservedObject var viewManager = ViewManager.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            switch viewManager.currentView {
            case .homeView:
                HomeView()
            case .playView:
                PlayMenuView()
            case .onlineView(let positions):
                OnlineMatchView(positions: positions)
            case .leaderboardView:
                LeaderboardView()
            case .settingsView:
                SettingsView()
            case .helpView:
                HelpView()
            case .unitsDeployerView(let gameType):
                UnitsDeployerView(gameType: gameType)
            case .aiVsAiGame:
                GameView(gameType: .aiVsAI)
            case .humanVsAiGame(let positions):
                GameView(gameType: .humanVsAI, player2Positions: positions)
            case .humanVsHumanGame(let gameID,
                                   let player1,
                                   let player2,
                                   let player1Positions,
                                   let player2Positions):
                GameView(gameType: .humanVsHuman,
                         gameID: gameID,
                         player1: player1,
                         player2: player2,
                         player1Positions: player1Positions,
                         player2Positions: player2Positions)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
    
