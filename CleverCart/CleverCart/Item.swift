//
//  Item.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import Foundation
import SwiftUI

struct Item: Codable, Equatable, Hashable {
    var id: String
    var name: String
    var description: String
    var quantity: Int
}

struct Items: Codable {
    var items = [Item]()
    
    mutating func add(_ new: Item, num: Int) {
        for (index, _) in items.enumerated() {
            if items[index] == new {
                items[index].quantity = num
                return
            }
        }
        var temp = new
        temp.quantity = num
        items.append(temp)
    }
}

struct PostItem: Codable {
    var token: String
    var item: Item
}
struct PostCart: Codable {
    var token: String
    var cart: [Item]
}
