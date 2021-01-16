//
//  LoginView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/9/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var token: FetchToken
    @Binding var generatedToken: Token
    @State private var username = ""
    @State private var password = ""
    
    @State private var user: User?
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
   
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .padding(16)
                    
                // allows user to enter their creds and verifies the user
                TextField("Username", text: $username)
                    .padding(.leading)
                    .foregroundColor(.green)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.1)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.green)
                    )
                    .padding(4)
                
                SecureField("Password", text: $password)
                    .padding(.leading)
                    .foregroundColor(.green)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.1)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.green)
                    )
                    .padding(4)
                    
                Button("Login") {
                    self.verify()
                    // may need while loop depending on threads
                    if (self.generatedToken.token != "") {
                        self.token.token = Token(token: self.generatedToken.token)
                        self.generatedToken = Token(token: "")
                        self.token.fetchAdmin()
                    }
                }
                .alert(isPresented: $showingAlert){
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
                }

                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .background(Color.green)
                .clipShape(Capsule())
                .padding(.top)
                
                Spacer()
            }
        }
        .accentColor( .black)
    }
    
    func verify() {
        // createUser func checks if the fields are empty; if they aren't create an User object for the current user
        func setUser() -> Bool {
            guard !self.username.trimmingCharacters(in: .whitespaces).isEmpty && !self.password.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
            user = User(username: self.username, password: self.password)
            return true
        }
        
        // prompts alerts if fields are empty
        guard setUser() else {
            self.alertTitle = "Incomplete Login"
            self.alertMessage = "Please fill in all required fields"
            self.showingAlert = true
            return
        }
        
        // encode user object to json format
        guard let encoded = try? JSONEncoder().encode(user) else {
            self.alertTitle = "Couldn't encode user"
            self.alertMessage = "User Auth Failed"
            self.showingAlert = true
            return
        }
        
        let url = URL(string: "")! // BACKEND URL NEEDED FOR USER TOKEN -> users/login: returns token
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                self.alertTitle = "Server Error"
                self.alertMessage = "Couldn't retrieve token"
                self.showingAlert = true
                return
            }
            
            // if token is returned properly set the var to toke returned
            if let decoded = try? JSONDecoder().decode(Token.self, from: data) {
                DispatchQueue.main.async {
                    self.generatedToken = decoded
                }
            }
                
            // token isn't returned so user is not found maybe
            else if let decoded = try? JSONDecoder().decode(Message.self, from: data){
                DispatchQueue.main.async{
                    self.alertTitle = "User Not Found"
                    self.alertMessage = "\(decoded.message)"
                    self.showingAlert.toggle()
                }
               return
            }
            
            // something went supa wrong
            else {
                DispatchQueue.main.async{
                    self.alertTitle = "Unknown Error"
                    self.alertMessage = "Unknown repsonse from server"
                    self.showingAlert.toggle()
                }
            }
        }.resume()
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
