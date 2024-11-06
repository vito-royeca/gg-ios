//
//  CreatePlayerView.swift
//  GG
//
//  Created by Vito Royeca on 11/4/24.
//

import SwiftUI

struct CreatePlayerView: View {
    @Environment(\.dismiss) var dismiss
    @State var username = ""
    
    @ObservedObject var playerManager = PlayerManager.shared
    
    var body: some View {
        VStack {
            Text("Enter your username that will be visible to other players.")
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding()
                
            HStack {
                Button {
                    dismiss()
                    ViewManager.shared.changeView(to: .homeView)
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)
                
                Button {
                    createPlayer()
                    dismiss()
                } label: {
                    Text("Submit")
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    func createPlayer() {
        playerManager.createPlayer(username: username)
    }
}

#Preview {
    CreatePlayerView()
}
