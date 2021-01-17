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
                    UserProductView(item: item, addToCart: addItem(item: item))
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
                    print(decoded.message)
                }
            }
            else {
                print("No response from server")
            }
        }.resume()
    }
}

struct UserProductView: View {
    var item: Item
    var addToCart: () //used to call function in UserItemView
    @State private var qtyToCart = 1
    @State private var addedToCart = false
    
    var body: some View {
        
        HStack {
            Color.gray
                .frame(width: 100, height: 100)
                .padding(.trailing)
            
            VStack (alignment: .leading, spacing: 4) {
                Text("\(item.name)")
                    .font(.system(size: 20.0))
                    .bold()
//                            Text("\(item.price)")
                HStack {
                    Text("QTY:")
                  
                    Image(systemName: "minus")
                        .onTapGesture{
                            if qtyToCart > 1 {
                                qtyToCart -= 1
                            }
                        }
                        .foregroundColor(.gray)
                    
                    Text("\(qtyToCart)")
                    
                    Image(systemName: "plus")
                        .onTapGesture{
                            if qtyToCart < item.quantity {
                                qtyToCart += 1
                            }
                        }
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(systemName: addedToCart ? "cart.fill" : "cart")
                .onTapGesture {
                    self.addToCart
                    addedToCart.toggle()
                }
                .padding()
                .foregroundColor(.green)
        }
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
