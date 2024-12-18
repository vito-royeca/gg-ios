//
//  ViewManager.swift
//  GG
//
//  Created by Vito Royeca on 11/5/24.
//

import SwiftUI

enum ViewKey: CaseIterable, Identifiable, Equatable {
    case homeView
    case playView
    case onlineView([GGBoardPosition]?)
    case leaderboardView
    case settingsView
    case helpView
    case unitsDeployerView(GameType)
    case aiVsAiGame
    case humanVsAiGame([GGBoardPosition])
    case humanVsHumanGame(String, FPlayer, FPlayer, [GGBoardPosition], [GGBoardPosition])
    
    static var allCases: [ViewKey] {
        return [.homeView,
                .playView,
                .onlineView(nil),
                .leaderboardView,
                .settingsView,
                .helpView,
                .unitsDeployerView(.aiVsAI),
                .unitsDeployerView(.humanVsAI),
                .unitsDeployerView(.humanVsHuman),
                .aiVsAiGame,
                .humanVsAiGame([]),
                .humanVsHumanGame("",
                                  FPlayer.emptyPlayer,
                                  FPlayer.emptyPlayer,
                                  [],
                                  [])]
    }
    
    var id: String {
        return self.description
    }
    
    var description: String {
        switch self {
        case .homeView:
            "Home"
        case .playView:
            "Play"
        case .onlineView:
            "Online Match"
        case .leaderboardView:
            "Leaderboard"
        case .settingsView:
            "Settings"
        case .helpView:
            "Help"
        case .unitsDeployerView(let gameType):
            "Units Deployer = (\(gameType.name))"
        case .aiVsAiGame:
            GameType.aiVsAI.name
        case .humanVsAiGame:
            GameType.humanVsAI.name
        case .humanVsHumanGame:
            GameType.humanVsHuman.name
        }
    }
}

class ViewManager: ObservableObject {
    
    // MARK: - Static properties

    public static let shared = ViewManager()
    

    // MARK: - Properties
    
    @Published var currentView:ViewKey = .homeView
    @Published var lastView:ViewKey = .homeView
    
    // MARK: - Initializers
    
    private init() {
            
    }
    
    // MARK: - Methods

    func changeView(to view: ViewKey) {
            
        // Ensure we are not already in the required view
        guard view != currentView else {
            return
        }
        
        switch(view) {
        case .homeView:
            ()
        default:
            break
        }
        
        lastView = currentView
        currentView = view

//            GKAccessPoint.shared.isActive = (GKLocalPlayer.local.isAuthenticated && view == .startNewGameView)
    }
}
