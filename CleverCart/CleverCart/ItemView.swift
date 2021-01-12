//
//  ItemView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/9/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ItemView: View {
    @Binding var screen: Int
    @State private var items = Items()
    @State private var showingImagePicker = false
    @State private var addingNewItem = false
    @State private var goingToCart = false
    
    //placeholder to test the different screens, shouldn't be hardcoded like this
    @State private var isAdmin = true
    
    @State private var inputImage: UIImage?
    @ObservedObject var handler = UserHandler()
    
    
    var addNewItem: some View {
        Button(action: {
            self.addingNewItem = true
        }) {
            Image(systemName: "plus")
                .padding(10)
        }
        .sheet(isPresented: $addingNewItem) {
            AddItemView(quantity: 1)
        }
        
    }
    
    var goToCart: some View {
        Button(action: {
            self.goingToCart = true
        }) {
            Image("cart")
                .padding(10)
        }
        .sheet(isPresented: $goingToCart) {
            //temporary
            CartView(screen: self.$screen, cart: Cart())

//            self.screen = 3
        }
    }
    
    var body: some View {
        NavigationView {
            //Placeholder, delete later
            Text("ItemView")
            
            
//            List {
//                ForEach(items.items, id: \.self) { item in
//                    HStack {
//                        VStack {
//                            Text("\(item.name)")
//                                .font(.title)
//                            Text("Quantity: \(item.quantity)")
//                        }
//
//                        Spacer()
//
//                        Button("Add") {
//                            Image(systemName: "plus")
//                            .onTapGesture {
//                                self.handler.addItem(token: "", name: item.name, quantity: "\(item.quantity)", link: "https://hkp-ios-demo-api.herokuapp.com/items/create")
//                            }
//                        }
//                    }
//                }
//            }
            .navigationBarTitle("Shop")
            .navigationBarItems(leading: isAdmin ? AnyView(EditButton()) : AnyView(EmptyView()), trailing: isAdmin ? AnyView(addNewItem) : AnyView(goToCart))
            
            
            
        }
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
