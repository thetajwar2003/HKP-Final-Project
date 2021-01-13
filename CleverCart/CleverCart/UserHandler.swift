//
//  User.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/9/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import Foundation

struct User: Codable {
    var username: String
    var password: String
    var admin: Bool = false
}

struct Token: Codable {
    var token: String
}

struct Admin: Decodable {
    var isAdmin: Bool
}

struct Message: Codable {
    var message: String
}

class FetchToken: ObservableObject {
    @Published var token: Token?
    @Published var isAdmin = false
    
    func fetchAdmin() {
        guard let encoded = try? JSONEncoder().encode(token) else {
            print("No token set")
            return
        }
        
        let url = URL(string: "")! // BACKEND URL  -> users/admin: return true or false
         var request = URLRequest(url: url)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode(Admin.self, from: data) {
                DispatchQueue.main.sync {
                    print(decoded.isAdmin)
                    self.isAdmin = decoded.isAdmin
                }
            } else {
                print("Invalid response")
            }
        }.resume()
    }
}
