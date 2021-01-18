//
//  AdminItemView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AdminItemView: View {
    @EnvironmentObject var token: FetchToken
    @Binding var items: Items
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items.items, id: \.self) { item in
                    HStack {
            //            Uncomment for functional pictures if item.photos had the urls to jpg files
            //            if item.photos != [] {
            //                Image(systemName: "photo")
            //                    .data(url: URL(string: item.photos[0])!)
            //                    .frame(width: 100, height: 100)
            //                    .padding(.trailing)
            //            } else {
                        Image(systemName: "photo")
                            .data(url: URL(string: "https://picsum.photos/200")!)
                            .frame(width: 100, height: 100)
                            .padding(.trailing)
            //            }
                        
                        VStack (alignment: .leading, spacing: 4) {
                            Text("\(item.name)")
                                .font(.system(size: 20.0))
                                .bold()
                            Text(String(format: "$%.2f", item.price))
            //                    Text("QTY: \(item.quantity)")
                        }

                    }
                }
                .onDelete(perform: removeItem)
            }
            .navigationBarTitle("Shop")
            // rhs button allows user to logout, lhs button allows user to refresh page
            .navigationBarItems(leading: Button("Logout") {
                self.token.token = nil
            }, trailing: Button("Reload") {
                self.fetchItems()
            })
        }
    }
    
    func removeItem(at offsets: IndexSet) {

        // this should take out the item the user wants to delete
        offsets.sorted(by: > ).forEach { (i) in
            updateItems(item: items.allItems[i])
        }
        items.allItems.remove(atOffsets: offsets)
    }
    
    func updateItems(item: Item) {
        var jsonifyItem = DeleteItem(_id: item._id)
        guard let encoded = try? JSONEncoder().encode(jsonifyItem) else { return }
        
        let url = URL(string: "https://storefronthkp.herokuapp.com/items/remove")! // BACKEND PART item/remove
        var req = URLRequest(url: url)
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "DELETE"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            print(response)
            print(error)
            guard let data = data else {
                print("No response")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded.message)
                }
            }
            else if let decoded = try? JSONDecoder().decode(Error.self, from: data){
                print(decoded)
                DispatchQueue.main.async{
                    print("error: \(decoded.ErrorType)")
                }
               return
            }
            else {
                do {
                          if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                               
                               // Print out entire dictionary
                               print(convertedJsonIntoDict)
                               
                               
                           }
                } catch let error as NSError {
                           print(error.localizedDescription)
                 }
            }
        }.resume()
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
