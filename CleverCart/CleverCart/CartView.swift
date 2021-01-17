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
    @Binding var cart: Items
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "cart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Your Cart")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .bold()
                Spacer()
                
                List {
                    // list of item and its quantity
                    ForEach (cart.items, id: \.id) { item in
                        CartProductView(item: item)
                    }.onDelete(perform: removeItem)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4)
                Spacer()
                
                Button("Checkout") {
                    checkout()
                }
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .background(Color.green)
                .clipShape(Capsule())
                
                Spacer()
            }
        }
    }
    
    // only removes the item from the list on user's device then calls api func
    func removeItem(at offsets: IndexSet) {
        cart.items.remove(atOffsets: offsets)
        self.updateCart()
    }
    
    // updates the cart to remove the items in the api
    func updateCart() {
        let jsonifyCart = PostCart(token: self.token.token!.token, cart: self.cart.items)
        
        guard let encoded = try? JSONEncoder().encode(jsonifyCart) else { return }
        
        let url = URL(string: "")! // BACKEND PART cart/remove
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("No response")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(Items.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded)
                    self.cart = decoded
                }
            }
            else {
                print("No response from server")
            }
        }.resume()
    }
    
    // allows the user to checkout and empties the cart
    func checkout() {
        let jsonifyCart = PostCart(token: self.token.token!.token, cart: self.cart.items)
        
        guard let encoded = try? JSONEncoder().encode(jsonifyCart) else { return }
        
        let url = URL(string: "")! // BACKEND PART cart/checkout
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("No response")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded.message)
                }
            }
            else {
                print("No response from server")
            }
        }.resume()
    }
}

struct CartProductView: View {
    var item: Item
    
    var body: some View {
        HStack {
            Color.gray
                .frame(width: 75, height: 75)
                .padding(.trailing)
            
            VStack (alignment: .leading, spacing: 4) {
                Text("\(item.name)")
                    .font(.system(size: 20.0))
                    .bold()
//                Text("\(item.price)")
                HStack {
                    Text("QTY:")
                  
                    Image(systemName: "minus")
                        .onTapGesture{
                            print("quantity minus 1")
                        }
                        .foregroundColor(.green)
                    Text("\(item.quantity)")
                    
                    Image(systemName: "plus")
                        .onTapGesture{
                            print("quantity minus 1")
                        }
                        .foregroundColor(.green)
                }
            }
        }
    }
}

