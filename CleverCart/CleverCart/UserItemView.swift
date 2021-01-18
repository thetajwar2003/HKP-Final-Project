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
            //            Uncomment for functional pictures if item.photos had the urls to jpg files
            //            if item.photos != [] {
            //                Image(systemName: "photo")
            //                    .data(url: URL(string: item.photos[0])!)
            //                    .frame(width: 100, height: 100)
            //                    .padding(.trailing)
            //            } else {
                        Image(systemName: "photo")
                            .data(url: URL(string: "https://picsum.photos/200")!)
                            .frame(width: 100, height: 100)
                            .padding(.trailing)
            //            }
                        
                        VStack (alignment: .leading, spacing: 4) {
                            Text("\(item.name)")
                                .font(.system(size: 20.0))
                                .bold()
                            Text(String(format: "$%.2f", item.price))
                        }

                        Spacer()

                        Image(systemName: "cart")
                            .onTapGesture {
                                self.addItem(item: item)
                            }
                            .padding()
                            .foregroundColor(.green)
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
        .accentColor(.green)
    }
    
    func addItem(item: Item) {
        // create an instance of cart item
        let addItem = CartItem(_id: "", item: item._id, price: Int(item.price), quantity: 1)
//        cart.cart.append(addItem)
        self.updateCart(item: addItem)
    }
    
    // updates the cart to remove the items in the api
    func updateCart(item: CartItem) {
        let jsonifyCart = AddToCart(_id: item.item, quantity: item.quantity, removeItem: false)
        guard let encoded = try? JSONEncoder().encode(jsonifyCart) else { return }
        
        let url = URL(string: "https://storefronthkp.herokuapp.com/cart/addItem")!
        var req = URLRequest(url: url)
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        // might need app.json
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
                    print(self.cart.items)
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
