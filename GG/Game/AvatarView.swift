//
//  AvatarView.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import SwiftUI

struct AvatarView: View {
    let player: GGPlayer
    let width: CGFloat
    let height: CGFloat
    
    @State var sizeDivider: CGFloat = 3
    @State var padding: CGFloat = 15
    
    var body: some View {
        if let avatarImage = player.avatarImage {
            avatarImage
              .resizable()
              .frame(width: width,
                     height: height)
              .clipShape(Circle())
        } else {
            Circle()
                .fill(player.avatarColor)
                .frame(width: width,
                       height: height)
        }
    }
}

#Preview {
    AvatarView(player: GGPlayer(displayName: "You", homeRow: GameViewModel.rows - 1),
               width: 60,
               height: 60)
}
