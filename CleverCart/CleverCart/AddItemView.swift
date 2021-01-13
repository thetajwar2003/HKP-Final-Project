//
//  AddItemView.swift
//  CleverCart
//
//  Created by Karina Zhang on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @State private var showingImagePicker = false
    @ObservedObject var handler = UserHandler()
    
    @State private var name = ""
    @State private var price = ""
    @State private var details = ""
    @State private var inputImage: UIImage?
    let id = UUID()
    let quantity: Int
    
    var saveButton: some View {
        Button("Save") {
            //will need to update this later
//             handler.addItem(token: "", name: self.name, quantity: "\(self.quantity)", link: "https://hkp-ios-demo-api.herokuapp.com/items/create")
        }
    }
    
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
                }
            }
            .navigationBarTitle(Text("Add Item"), displayMode: .inline)
            .navigationBarItems(trailing: saveButton)
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(quantity: Int())
    }
}
