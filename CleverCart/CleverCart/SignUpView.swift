//
//  SignUp.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @Binding var screen: Int
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack () {
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
                    
                Text("Signup")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue.opacity(0.75))
                    .clipShape(Capsule())
                    .onTapGesture {
                        self.screen = 3
                    }
                
            }
        }
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
