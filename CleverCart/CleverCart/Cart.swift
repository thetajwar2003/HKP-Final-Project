//
//  Cart.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/9/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import Foundation

class Cart: ObservableObject {
    @Published var cart = [Item]() {
        willSet {
            objectWillChange.send()
        }
    }
    func add(_ item: Item) {
        objectWillChange.send()
        cart.append(item)
    }
}
