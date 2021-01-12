//
//  CartView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct CartView: View {
    @Binding var screen: Int
    @ObservedObject var cart: Cart
    @ObservedObject var handler = UserHandler()
    
    var body: some View {
        //Placeholder, delete later
        Text("CartView")
//        NavigationView {
//            List {
//                ForEach(cart.cart, id: \.self) { item in
//                    Text(item.name)
//                    Text("\(item.quantity)")
//                }.onDelete(perform: deleteItem)
//            }
//        }
    }
    func deleteItem(at offsets: IndexSet) {
        cart.cart.remove(atOffsets: offsets)
    }
}

