//
//  AvatarView.swift
//  GG
//
//  Created by Vito Royeca on 10/31/24.
//

import SwiftUI

struct AvatarView: View {
    var geometry: GeometryProxy
    
    @State var sizeDivider: CGFloat = 3
    @State var padding: CGFloat = 15
    
    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: geometry.size.width / 6,
                   height: geometry.size.width / 6)
            .onAppear {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    sizeDivider = 5
                }
            }
    }
}

#Preview {
    GeometryReader { geometry in
        AvatarView(geometry: geometry)
    }
}
