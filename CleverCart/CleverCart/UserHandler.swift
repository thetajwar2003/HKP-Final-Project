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
}

struct Item: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var quantity: Int
}

class Items: ObservableObject {
    @Published var items = [Item]() {
        willSet {
            objectWillChange.send()
        }
    }
}

class UserHandler: ObservableObject {
    // should work for logging in and sign up
    func auth(username: String, password: String, link: String) {
        let info = ["username": username, "password": password]
        
        // encodes info to a json object
        guard let encoded = try? JSONEncoder().encode(info) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: link)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown Error").")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(User.self, from: data) {
                print(decoded)
            }
            else {
                print(error?.localizedDescription as Any)
            }
        }.resume()
    }
    
    // get items
    func getCart(token: String, link: String) {
        var components = URLComponents(string: link)!
        components.queryItems = [URLQueryItem(name: "token", value: token)]
            
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown Error").")
                return
            }
            
            if let decoded = try? JSONDecoder().decode([Item].self, from: data) {
                print(decoded)
            }
            else {
                print(error?.localizedDescription as Any)
            }
        }.resume()
    }
    
    //delete item
    func deleteItem(token: String, id: String, link: String) {
        let info = ["token": token, "id": id]
        
        // encodes info to a json object
        guard let encoded = try? JSONEncoder().encode(info) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: link)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown Error").")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(User.self, from: data) {
                print(decoded)
            }
            else {
                print(error?.localizedDescription as Any)
            }
        }.resume()
    }
    
    // add item to cart
    func addItem(token: String, name: String, quantity: String, link: String) {
        let info = ["token": token, "name": name, "quantity": quantity]
        
        // encodes info to a json object
        guard let encoded = try? JSONEncoder().encode(info) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: link)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown Error").")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(User.self, from: data) {
                print(decoded)
            }
            else {
                print(error?.localizedDescription as Any)
            }
        }.resume()
    }
}

