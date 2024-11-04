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
    
    var playerAuth: PlayerAuthModel
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding()
                
            HStack {
                Button {
                    dismiss()
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
        playerAuth.createPlayer(username: username)
    }
}

#Preview {
    CreatePlayerView(playerAuth: PlayerAuthModel())
}
