//
//  CartView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var token: FetchToken
    @Binding var cart: CartList
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    List {
                        // list of item and its quantity
                        ForEach (cart.items, id: \._id) { item in
                            HStack {
                                Text("\(item._id)")
                                Text("\(item.price)")
                                Text("\(item.quantity)")
                            }
                        }.onDelete(perform: removeItem)
                    }
                }
                
                Section {
                    Button("Checkout") {
                        self.checkout()
                    }
                }
            }
            .navigationBarItems(leading: Button("Logout") {
                // TODO FIX LOGOUT
                self.token.token = Token(token: "", adminInfo: false)
            }, trailing: Button("Reload") {
                self.fetchCart()
            })
        }
    }
    
    // only removes the item from the list on user's device then calls api func
    func removeItem(at offsets: IndexSet) {
        // this should take out the item the user wants to delete
        offsets.sorted(by: > ).forEach { (i) in
            updateCart(item: cart.items[i])
        }
//        cart.items.remove(atOffsets: offsets)
    }
    
    // updates the cart to remove the items in the api
    func updateCart(item: CartItem) {
        let jsonifyCart = AddToCart(_id: item.item, quantity: item.quantity, removeItem: true)
        guard let encoded = try? JSONEncoder().encode(jsonifyCart) else { return }
        
        let url = URL(string: "https://storefronthkp.herokuapp.com/cart/addItem")!
        var req = URLRequest(url: url)
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "PUT"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in

            guard let data = data else {
                print("\(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decoded = try? JSONDecoder().decode(NewCart.self, from: data) {
                DispatchQueue.main.async {
                    self.cart.items = decoded.newCart.cart
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
                print("big time mess up in deleting item from cart")
            }
        }.resume()
    }
    
    func fetchCart() {
        let url = URL(string: "https://storefronthkp.herokuapp.com/cart/view")!
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
                print(decoded)
                DispatchQueue.main.async{
                    print(decoded.ErrorType)
                }
               return
            }
            else {
                print("big time mess up in fetch cart")
            }
        }.resume()
    }
    
    // allows the user to checkout and empties the cart
    func checkout() {
        let url = URL(string: "https://storefronthkp.herokuapp.com/cart/checkout")! // BACKEND PART cart/checkout
        var req = URLRequest(url: url)
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("No response")
                return
            }

            if let decoded = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded.Message)
                }
            }
            else if let decoded = try? JSONDecoder().decode(Error.self, from: data){
                print(decoded)
                DispatchQueue.main.async{
                    print(decoded.ErrorType)
                }
               return
            }
            else {
                self.cart.items = []
            }
        }.resume()
    }
}

