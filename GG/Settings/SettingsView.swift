//
//  SettingsView.swift
//  GG
//
//  Created by Vito Royeca on 11/1/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var homeScreenKey: HomeScreenKey?
    
    var body: some View {
        VStack {
            Text("Settings")
            
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
    SettingsView(homeScreenKey: .constant(nil))
}
