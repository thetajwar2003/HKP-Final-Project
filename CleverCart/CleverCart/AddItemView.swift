//
//  AddItemView.swift
//  CleverCart
//
//  Created by Karina Zhang on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @Binding var items: Items
    @State private var showingImagePicker = false
    
    @State private var name = ""
    @State private var price = ""
    @State private var details = ""
    @State private var inputImage: UIImage?
    @State private var quantity = 1

    let id = UUID().uuidString
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.showingImagePicker = true
                }) {
                    ZStack {
                        Color.gray
                            .frame(width: 300, height: 200)
                        
                        if inputImage != nil {
                            Image(uiImage: inputImage ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 200)
                        }
                        else {
                            Text("Click to add a photo")
                                .foregroundColor(Color.white)
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: self.$inputImage)
                }
                
                
                Form {
                    Section(header: Text("Info")) {
                        TextField("Name", text: $name)
                        TextField("Price", text: $price)
                        TextField("Details", text: $details)
                    }
                    Section(header: Text("Quantity")) {
                        Stepper(value: $quantity, in: 1...10, step: 1) {
                            Text("\(quantity)")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Add Item"))
            .navigationBarItems(trailing:
                Button("Save") {
                    let newItem = Item(id: id, name: name, description: details, quantity: quantity)
                    addItem(item: newItem)
                }
            )
        }
    }
    
    func addItem(item: Item) {
        items.items.append(item)
        self.updateItems()
    }
    
    // updates items to add the new item in the api
    func updateItems() {
        let jsonifyItems = self.items
        
        guard let encoded = try? JSONEncoder().encode(jsonifyItems) else { return }
        
        let url = URL(string: "")! // BACKEND PART items/add
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

//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView(items: Items())
//    }
//}
