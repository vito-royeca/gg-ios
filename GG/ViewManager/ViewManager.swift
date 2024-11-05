//
//  ViewManager.swift
//  GG
//
//  Created by Vito Royeca on 11/5/24.
//

import SwiftUI

enum ViewKey: CaseIterable, Identifiable {
    case home, play, playAiVsAi, playHumanVsAi, playOnline, leaderboard, settings, help
    
    var id: Self {
        return self
    }
    
    var description: String {
        switch self {
        case .home:
            "Home"
        case .play:
            "Play"
        case .playAiVsAi:
            "Ai vs. AI"
        case .playHumanVsAi:
            "Human vs. AI"
        case .playOnline:
            "Online Match"
        case .leaderboard:
            "Leaderboard"
        case .settings:
            "Settings"
        case .help:
            "Help"
        }
    }
}

class ViewManager: ObservableObject {
    
    // MARK: - Static properties

    public static let shared = ViewManager()
    

    // MARK: Properties
    
    // MARK: - Properties
    @Published var currentView:ViewKey = .home
    @Published var lastView:ViewKey = .home
    
    // MARK: - Initializers
    
    required init() {
            
    }
    
    // MARK: - Methods

    func changeView(to view: ViewKey) {
            
        // Ensure we are not already in the required view
        guard view != currentView else {
            return
        }
        
        switch(view) {
        case .home:
            ()
        default:
            break
        }
        
        lastView = currentView
        currentView = view

//            GKAccessPoint.shared.isActive = (GKLocalPlayer.local.isAuthenticated && view == .startNewGameView)
    }
}
