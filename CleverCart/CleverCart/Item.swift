//
//  Item.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import Foundation

struct Item: Codable, Equatable, Hashable {
    var __v: Int
    var _id: String
    var category: String
    var description: String
    var name: String
    var photos: [String]
    var price: Double
//    var quantity: Int
}

struct Items: Codable {
    var allItems = [Item]()
}

struct CartItem: Codable, Equatable, Hashable {
    var _id: String
    var item: String
    var price: Int
    var quantity: Int
}

struct CartList: Codable {
    var items = [CartItem]()
}

struct Cart: Codable {
    var _id: String
    var username: String
    var cart = [CartItem]()
    var __v: Int
}

struct NewCart: Codable {
    var newCart: Cart
}

struct DeleteItem: Codable {
    var _id: String
}
struct AddToCart: Codable {
    var _id: String
    var quantity: Int
    var removeItem: Bool
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
