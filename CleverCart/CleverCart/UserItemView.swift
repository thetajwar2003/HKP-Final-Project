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
                ForEach(items.items, id: \.self) { item in
                    HStack {
                        //add image
                        VStack {
                            Text("\(item.name)")
                                .font(.title)
            //                Text("\(item.price)")
                            Text("Quantity: \(item.quantity)")
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
        }
    }
    
    func addItem(item: Item) {
        cart.items.append(item)
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
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
