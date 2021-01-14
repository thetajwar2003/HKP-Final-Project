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
                NavigationLink(destination: LoginView(generatedToken: $generatedToken)) {
                    Text("Login")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.75))
                        .clipShape(Capsule())
                }
                NavigationLink(destination: SignUpView(generatedToken: $generatedToken)){
                    Text("Sign Up")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.75))
                        .clipShape(Capsule())
                }
            }// add bar title
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
