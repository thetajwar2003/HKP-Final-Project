//
//  User.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/9/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import Foundation

struct User: Codable {
    var username: String
    var password: String
    var admin: Bool = false
}

struct Admin: Decodable {
    var isAdmin: Bool
}

struct Message: Codable {
    var message: String
}

struct Token: Codable {
    var token: String
}

class FetchToken: ObservableObject {
    @Published var token: Token?
}
