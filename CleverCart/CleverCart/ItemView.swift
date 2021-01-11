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
    @ObservedObject var handler = UserHandler()
    
    var body: some View {
        NavigationView {
            //Placeholder, delete later
            VStack {
                Text("ItemView")
                
                Text("Go to cart")
                    .onTapGesture {
                        screen = 3
                    }
            }
            
            
            List {
                ForEach(items.items, id: \.self) { item in
                    HStack {
                        VStack {
                            Text("\(item.name)")
                                .font(.title)
                            Text("Quantity: \(item.quantity)")
                        }
                        
                        Spacer()
                        
                        Button("Add") {
                            Image(systemName: "plus")
                            .onTapGesture {
                                    handler.addItem(token: "", name: item.name, quantity: "\(item.quantity)", link: "https://hkp-ios-demo-api.herokuapp.com/items/create")
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
