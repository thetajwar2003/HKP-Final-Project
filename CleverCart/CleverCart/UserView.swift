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
    @State private var cart = CartList()
    @State private var items = Items()
    
    var body: some View {
        TabView {
            // shows list of all products available
            UserItemView(items: $items, cart: $cart) // TODO pass in cart to add item to cart and remember to post!!
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Store")
                }
            .onAppear{self.fetchItems()}
            
            // shows list of items in a user's cart
            CartView(cart: $cart)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }.onAppear{self.fetchCart()}
        }
        .accentColor(.green)
    }
    
    // retrieves all the products in the store
    func fetchItems() {
        let url = URL(string: "https://storefronthkp.herokuapp.com/items/get/all")!
        var req = URLRequest(url: url)
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("\(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decoded = try? JSONDecoder().decode(Items.self, from: data) {
                DispatchQueue.main.async {
                    self.items.allItems = decoded.allItems
                }
            }
            else if let decoded = try? JSONDecoder().decode(Message.self, from: data){
                DispatchQueue.main.async{
                    print(decoded.Message)
                }
               return
            }
            else if let decoded = try? JSONDecoder().decode(Error.self, from: data){
                DispatchQueue.main.async{
                    print(decoded.ErrorType)
                }
               return
            }
            else {
                print("big time mess up")
            }
        }.resume()
    }
    
    // retrieves the items inside the cart and sets it to the cart property
    func fetchCart() {
        let url = URL(string: "https://storefronthkp.herokuapp.com/cart/view")! // BACKEND URL NEEDED -> /cart: returns a list of items
        var req = URLRequest(url: url)
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("\(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decoded = try? JSONDecoder().decode(CartList.self, from: data) {
                DispatchQueue.main.async {
                    self.cart.items = decoded.items
                }
            }
            else if let decoded = try? JSONDecoder().decode(Message.self, from: data){
                DispatchQueue.main.async{
                    print(decoded.Message)
                }
               return
            }
            else if let decoded = try? JSONDecoder().decode(Error.self, from: data){
                DispatchQueue.main.async{
                    print(decoded.ErrorType)
                }
               return
            }
            else {
                print("bigmess up in fetch cart")
            }
        }.resume()
    }
}
