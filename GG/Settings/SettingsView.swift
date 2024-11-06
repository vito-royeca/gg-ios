//
//  SettingsView.swift
//  GG
//
//  Created by Vito Royeca on 11/1/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
            
            Button {
                ViewManager.shared.changeView(to: .homeView)
            } label: {
                Text("Home")
            }
            .buttonStyle(.bordered)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GGConstants.menuViewBackgroundColor)
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
}
