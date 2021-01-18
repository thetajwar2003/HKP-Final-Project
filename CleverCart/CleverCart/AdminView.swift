//
//  AdminView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var token: FetchToken
    @State private var items = Items()
    
    var body: some View {
        TabView {
            // shows the products available in the store
            AdminItemView(items: $items)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Products")
                }.onAppear{self.fetchItems()}
            
            // allows admins to add items
            AddItemView(items: $items)
                .tabItem {
                    Image(systemName: "text.badge.plus")
                    Text("Add Item")
                }
        }
        .accentColor(.green)
    }
    
    // retrieves all the products in the store
    func fetchItems() {
        let url = URL(string: "https://storefronthkp.herokuapp.com/items/get/all")!
        var req = URLRequest(url: url)
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("\(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decoded = try? JSONDecoder().decode(Items.self, from: data) {
                DispatchQueue.main.async {
                    self.items.allItems = decoded.allItems
                }
            }
            else if let decoded = try? JSONDecoder().decode(Message.self, from: data){
                DispatchQueue.main.async{
                    print(decoded.Message)
                }
               return
            }
            else if let decoded = try? JSONDecoder().decode(Error.self, from: data){
                print(decoded)
                DispatchQueue.main.async{
                    print(decoded.ErrorType)
                }
               return
            }
            else {
                print("big time mess up")
            }
        }.resume()
    }
}


struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
