//
//  SignUp.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var token: FetchToken
    
    @State private var username = ""
    @State private var password = ""
    @State private var reEnterPass = ""
    
    @State private var user: User?
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            
            VStack () {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .padding(16)
                
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
                
                    SecureField("Re-Enter Password", text: $reEnterPass)
                        .padding(.leading)
                        .foregroundColor(.green)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.1)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.green)
                        )
                        .padding(4)
                    
                
                    
                Button("Sign Up") {
                    self.authenticate()
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
        .accentColor(.green)
    }
    func authenticate() {
        // checks if the fields are empty and if the password fields are the same
        func createUser() -> Bool {
            guard !self.username.trimmingCharacters(in: .whitespaces).isEmpty && !self.password.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
            guard self.password == self.reEnterPass else { return false }
            user = User(username: self.username, password: self.password, isAdmin: false)
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
        
        let url = URL(string: "https://storefronthkp.herokuapp.com/users/create")!
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
                    self.token.token = Token(token: decoded.token, adminInfo: decoded.adminInfo)
    
                    if(self.token.token?.token != nil){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
                
            // token isn't returned so user is not found maybe
            else if let decoded = try? JSONDecoder().decode(Message.self, from: data){
                print(decoded)
                DispatchQueue.main.async{
                    self.alertTitle = "User could not be created"
                    self.alertMessage = "\(decoded.Message)"
                    self.showingAlert.toggle()
                }
               return
            }
            
            // something went supa wrong
            else if let decoded = try? JSONDecoder().decode(Error.self, from: data){
                print(decoded)
                DispatchQueue.main.async{
                    self.alertTitle = "User could not be created"
                    self.alertMessage = "\(decoded.ErrorType)"
                    self.showingAlert.toggle()
                }
               return
            }
        }.resume()
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
