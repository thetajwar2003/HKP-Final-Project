//
//  SignUp.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var token: FetchToken
    @Binding var generatedToken: Token
    @State private var username = ""
    @State private var password = ""
    @State private var reEnterPass = ""
    
    @State private var user: User?
    @State private var admin = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            
            VStack () {
                Form {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    SecureField("Re-Enter Password", text: $reEnterPass)
                    
                    Toggle(isOn: $admin){
                        Text("Admin")
                    }
                }
                    
                Button("Sign Up") {
                    self.authenticate()
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
                .foregroundColor(.green)
                .padding(12)
            }
            .navigationBarTitle("Welcome!")
        }
    }
    func authenticate() {
        // checks if the fields are empty and if the password fields are the same
        func createUser() -> Bool {
            guard !self.username.trimmingCharacters(in: .whitespaces).isEmpty && !self.password.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
            guard self.password == self.reEnterPass else { return false }
            user = User(username: self.username, password: self.password, admin: self.admin)
            return true
        }
        
        guard createUser() else {
            self.alertTitle = "Incomplete Login"
            self.alertMessage = "Please fill in all required fields/Passwords do not Match"
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
        
        let url = URL(string: "")! // BACKEND URL NEEDED FOR USER TOKEN -> users/signup: returns token
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
                    self.alertTitle = "User could not be created"
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

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
