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
                ForEach(items.allItems, id: \._id) { item in
                    HStack {
                        //add image
                        VStack {
                            Text("\(item.name)")
                                .font(.title)
                            Text("\(item.price)")
//                            Text("Quantity: \(item.quantity)")
                        }
                    }
                }
                .onDelete(perform: removeItem)
            }
            .navigationBarTitle("Shop")
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
                    print(decoded.Message)
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
}


