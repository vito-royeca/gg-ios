//
//  OnlineMatchView.swift
//  GG
//
//  Created by Vito Royeca on 11/2/24.
//

import SwiftUI

struct OnlineMatchView: View {
    @StateObject var userAuth: UserAuthModel =  UserAuthModel()
    @Binding var homeScreenKey: HomeScreenKey?
    
    fileprivate func SignInButton() -> Button<Text> {
        Button(action: {
            userAuth.signIn()
        }) {
            Text("Sign In")
        }
    }
    
    fileprivate func SignOutButton() -> Button<Text> {
        Button(action: {
            userAuth.signOut()
        }) {
            Text("Sign Out")
        }
    }
    
    fileprivate func ProfilePic() -> some View {
        AsyncImage(url: URL(string: userAuth.profilePicUrl))
            .frame(width: 100, height: 100)
    }
    
    fileprivate func UserInfo() -> Text {
        return Text(userAuth.givenName)
    }
        
    var body: some View {
        VStack{
            Text("Online Match")
            UserInfo()
            ProfilePic()
            
            if (userAuth.isLoggedIn){
                SignOutButton()
            } else {
                SignInButton()
            }
            Text(userAuth.errorMessage)
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
    OnlineMatchView(homeScreenKey: .constant(nil))
}
