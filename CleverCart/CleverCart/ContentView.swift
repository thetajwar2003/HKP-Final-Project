//
//  ContentView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var items = Items()
    @State private var screen = 0
    @ObservedObject var cart = Cart()
    var body: some View {
        Group {
            if screen == 0 {
                LoginView(screen: $screen)
            }
            if screen == 1{
                SignUpView(screen: $screen)
            }
            if screen == 2{
                ItemView(screen: $screen)
            }
            if screen == 3{
                CartView(screen: $screen, cart: cart)
            }
        }
        .environmentObject(items)
        .environmentObject(cart)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
