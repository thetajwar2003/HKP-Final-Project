//
//  ItemView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/9/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct UserItemView: View {
    @EnvironmentObject var token: FetchToken
    @Binding var items: Items
    @Binding var cart: CartList
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items.allItems, id: \._id) { item in
                    HStack {
                        //add image
                        VStack {
                            Text("\(item.name)")
                                .font(.title)
                            Text("\(item.price)")
                            //may have to hardcode quantity
//                            Text("Quantity: \(item.quantity)")
                        }

                        Spacer()
                        Image(systemName: "plus")
                            .onTapGesture {
                                self.addItem(item: item)
                            }
                    }
                }
                
            }
            .navigationBarTitle("Shop")
            // rhs button allows user to logout, lhs button allows user to refresh page
            .navigationBarItems(leading: Button("Logout") {
                // TODO FIX LOGOUT
                self.token.token = Token(token: "", adminInfo: false)
            }, trailing: Button("Reload") {
                self.fetchItems()
            })
        }
    }
    
    func addItem(item: Item) {
        // create an instance of cart item
        let addItem = CartItem(_id: "", item: item._id, price: item.price, quantity: 1)
        cart.cart.append(addItem)
        self.updateCart(item: addItem)
    }
    
    // updates the cart to remove the items in the api
    func updateCart(item: CartItem) {
        let jsonifyCart = PostCart(_id: item._id, quantity: item.quantity, removeItem: false)
        
        guard let encoded = try? JSONEncoder().encode(jsonifyCart) else { return }
        
        let url = URL(string: "https://storefronthkp.herokuapp.com/cart/addItem")!
        var req = URLRequest(url: url)
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        // might need app.json
        req.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "PUT"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("\(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decoded = try? JSONDecoder().decode(NewCart.self, from: data) {
                DispatchQueue.main.async {
                    self.cart.cart = decoded.newCart.cart
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
                print("big time mess up in adding item to cart")
            }
        }.resume()
    }
    
    
    // TODO THIS IS A REPEATED FUNCTION MODULARIZE LATER
    // retrieves all the products in the store
    func fetchItems() {
        print("here user view")
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
                print(decoded)
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
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
