//
//  AdminItemView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AdminItemView: View {
    @Binding var items: Items
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items.items, id: \.self) { item in
                    AdminProductView(item: item)
                }
                .onDelete(perform: removeItem)
            }
            .navigationBarTitle("Shop")
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        items.items.remove(atOffsets: offsets)
        self.updateItems()
    }
    
    func updateItems() {
        let jsonifyItems = Items(items: items.items)
        
        guard let encoded = try? JSONEncoder().encode(jsonifyItems) else { return }
        
        let url = URL(string: "")! // BACKEND PART item/remove
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("No response")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded.message)
                }
            }
            else {
                print("No response from server")
            }
        }.resume()
    }
}

struct AdminProductView: View {
    var item: Item
    
    var body: some View {
        HStack {
            Color.gray
                .frame(width: 100, height: 100)
                .padding(.trailing)
            
            VStack (alignment: .leading, spacing: 4) {
                Text("\(item.name)")
                    .font(.system(size: 20.0))
                    .bold()
//                            Text("\(item.price)")
                    Text("QTY: \(item.quantity)")
            }

        }
    }
}

//struct AdminItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminItemView()
//    }
//}
