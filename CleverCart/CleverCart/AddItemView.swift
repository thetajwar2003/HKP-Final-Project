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
                HStack (alignment: .top){
                    //IMAGE START
                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        ZStack {
                            Color.gray
                                .frame(width: 150, height: 150)
                            
                            if inputImage != nil {
                                Image(uiImage: inputImage ?? UIImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                            }
                            else {
                                Text("Add a photo")
                                    .foregroundColor(Color.white)
                            }
                        }
                        .padding()
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: self.$inputImage)
                    }
                    //IMAGE END
                    
                    VStack {
                        TextField("Name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top)
                        TextField("Price", text: $price)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                        Text("QTY")
                        HStack {
                            Image(systemName: "minus")
                                .onTapGesture{
                                    quantity -= 1
                                }
                                .foregroundColor(.gray)
                            
                            Text("\(quantity)")
                            
                            Image(systemName: "plus")
                                .onTapGesture{
                                    quantity += 1
                                }
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.trailing)
                } //END OF HEADER SECTION
                
                Text("Description")
                if #available(iOS 14.0, *) {
                    TextEditor(text: $details)
                        .foregroundColor(.black)
                        .border(Color.gray)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/3)
                } else {
                    // Fallback on earlier versions
                    TextField("Description", text: $details)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/3)
                }
                
                Spacer()

            }
            .navigationBarTitle(Text("Add Item"))
            .navigationBarItems(trailing:
                Button("Save") {
                    let newItem = Item(id: self.id, name: self.name, description: self.details, quantity: self.quantity)
                    
                    self.addItem(item: newItem)
                }
                    .foregroundColor(.green)
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
        
        let url = URL(string: "https://storefronthkp.herokuapp.com/items/upload")! // BACKEND PART items/add
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = encoded
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data else {
                print("No response")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(Items.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded)
                    self.items = decoded
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
