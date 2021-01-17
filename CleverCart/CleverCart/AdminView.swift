//
//  AdminView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var token: FetchToken
    @State private var items = Items()
    
    var body: some View {
        TabView {
            // shows the products available in the store
            AdminItemView(items: $items)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Products")
                }
            
            // allows admins to add items
            AddItemView(items: $items)
                .tabItem {
                    Image(systemName: "text.badge.plus")
                    Text("Add Item")
                }
        }
        // rhs button allows user to logout, lhs button allows user to refresh page
        .navigationBarItems(leading: Button("Logout") {
            self.token.token = nil
        }, trailing: Button("Reload") {
            self.fetchItems()
        })
        .accentColor(.green)
    }
    
    func fetchItems() {
        guard let encoded = try? JSONEncoder().encode(token.token) else {
            print("error encoding token")
            return
        }
        
        let url = URL(string: "")! // BACKEND URL NEEDED -> /item: returns a list of items
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("\(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decoded = try? JSONDecoder().decode(Items.self, from: data) {
                DispatchQueue.main.async {
                    self.items = decoded
                }
            } else {
                print("Server error")
            }
        }.resume()
    }
}

