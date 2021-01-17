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
    @Binding var cart: Items
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items.allItems, id: \.self) { item in
                    HStack {
                        //add image
                        VStack {
                            Text("\(item.name)")
                                .font(.title)
                            Text("\(item.price)")
//                            Text("Quantity: \(item.quantity)")
                        }

                        Spacer()

                        Button("Add") {
                            Image(systemName: "plus")
                                .onTapGesture {
                                    self.addItem(item: item)
                                }
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
        cart.allItems.append(item)
        self.updateCart()
    }
    
    // updates the cart to remove the items in the api
    func updateCart() {
        let jsonifyCart = PostCart(token: self.token.token!.token, cart: self.cart.allItems)
        
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
            
            if let decoded = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded.Message)
                }
            }
            else {
                print("No response from server")
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
