//
//  HelpView.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI

struct HelpView: View {
    @Binding var homeScreenKey: HomeScreenKey?
    
    var body: some View {
        VStack {
            Text("Help")
            
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
    HelpView(homeScreenKey: .constant(nil))
}
