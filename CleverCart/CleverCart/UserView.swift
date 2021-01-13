//
//  UserView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var token: FetchToken
    @State var cart = Items()
    
    var body: some View {
        TabView {
            // shows list of all products available
            ItemView() // TODO pass in cart to add item to cart and remember to post!!
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Store")
            }
            
            // shows list of items in a user's cart
            CartView() // TODO pass in cart to show cart items
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
            }
        }
    }
    
    // retrieves the items inside the cart and sets it to the cart property
    func fetchCart() {
        guard let encoded = try? JSONEncoder().encode(token.token) else {
            print("error encoding token")
            return
        }
        
        let url = URL(string: "")! // BACKEND URL NEEDED -> /cart: returns a list of items
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
                    self.cart = decoded
                }
            } else {
                print("Server error")
            }
        }.resume()
    }
}
