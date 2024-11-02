//
//  LeaderboardView.swift
//  GG
//
//  Created by Vito Royeca on 11/1/24.
//

import SwiftUI

struct LeaderboardView: View {
    @Binding var homeScreenKey: HomeScreenKey?
    
    var body: some View {
        VStack {
            Text("Leaderboard")
            
            Button {
                homeScreenKey = nil
            } label: {
                Text("Home")
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    LeaderboardView(homeScreenKey: .constant(nil))
}
