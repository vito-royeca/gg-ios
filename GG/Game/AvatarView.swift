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
        Circle()
            .fill(player.isBottomPlayer ? .white : .black)
            .frame(width: width,
                   height: height)
    }
}

#Preview {
    GeometryReader { geometry in
        AvatarView(player: GGPlayer(),
                   width: 60,
                   height: 60)
    }
}
