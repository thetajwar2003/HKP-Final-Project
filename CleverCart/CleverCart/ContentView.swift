//
//  ContentView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var token: FetchToken
    @State var generatedToken: Token
    var body: some View {
        if (token.token != nil) {
            if(token.isAdmin) {
                AdminView()
            }
            else {
                UserView()
            }
        }
        return NavigationView {
            VStack {
                Spacer()
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
                Text("Tree Store")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color.green)
                    .padding(16)
                Text("Save some $$$ while saving the planet")
                    .font(.system(size: 18.0))
                    .bold()
                    .foregroundColor(Color.green)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .multilineTextAlignment(.center)
                    .padding(4)
                
                Text("Your one stop shop for all your tree-related needs")
                    .font(.system(size: 16.0))
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .multilineTextAlignment(.center)
                Spacer()
                
                
                NavigationLink(destination: LoginView(generatedToken: $generatedToken)) {
                    Text("Login")
                        .fontWeight(.black)
                        .foregroundColor(.green)
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.width * 0.125)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.green)
                        )
                        .padding(4)
                }
                
                NavigationLink(destination: SignUpView(generatedToken: $generatedToken)){
                    Text("Sign Up")
                        .fontWeight(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.width * 0.125)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .clipShape(Capsule())
                }
                Spacer()
                
            }
        }
        .accentColor( .green)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
