//
//  AdminView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    var body: some View {
        TabView {
            // shows the products available in the store
            AdminItemView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Products")
            }
            
            // allows admins to add items
            AddItemView()
                .tabItem {
                    Image(systemName: "text.badge.plus")
                    Text("Add Item")
            }
        }
    }
}

