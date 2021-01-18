//
//  AddItemView.swift
//  CleverCart
//
//  Created by Karina Zhang on 1/12/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var token: FetchToken
    @Binding var items: Items
    @State private var showingImagePicker = false
    
    @State private var name = ""
    @State private var price = ""
    @State private var details = ""
    @State private var inputImage: UIImage?
    @State private var quantity = 1
    @State private var category = ""

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
                        TextField("Category", text: $category)
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
                    let newItem = Item(__v: 0, _id: self.id, category: self.category, description: self.details, name: self.name, photos: [], price: Double(self.price)!)
                    
                    self.addItem(item: newItem)
                }
            )
        }
    }
    
    func addItem(item: Item) {
//        items.allItems.append(item)
//        self.updateItems()
        let url = "https://storefronthkp.herokuapp.com/items/upload"
        let bundlePath = Bundle.main.path(forResource: self.name, ofType: "jpeg")!
        let img = UIImage(contentsOfFile: bundlePath)!
        let data: Data = img.jpegData(compressionQuality: 1)!
        
        self.updateItems(urlPath: url, fileName: "\(self.name).jpeg", data: data)
    }
    
    // updates items to add the new item in the api
    func updateItems(urlPath:String, fileName:String, data:Data){
        let formFields = ["name": self.name, "price": self.price, "description": self.details]
        
        let url = URL(string: urlPath)!
        var req = URLRequest(url: url)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let fullData = photoDataToFormData(data: data,boundary: boundary,fileName: fileName)

        
        req.addValue("Bearer \(self.token.token!.token)", forHTTPHeaderField: "Authorization")
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "PUT"
        req.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
        
        let httpBody = NSMutableData()
        for (key, value) in formFields {
            httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
        }
        httpBody.append(fullData)
        
        httpBody.appendString("--\(boundary)--")

        req.httpBody = httpBody as Data

        print(String(data: httpBody as Data, encoding: .utf8)!)

        
        URLSession.shared.dataTask(with: req) { data, response, error in
            print(response)
            guard let data = data else {
                print("No response")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(Message.self, from: data){
                DispatchQueue.main.async{
                    print(decoded.Message)
                }
               return
            }
            else if let decoded = try? JSONDecoder().decode(Error.self, from: data){
                DispatchQueue.main.async{
                    print(decoded.ErrorType)
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
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }
    
    func photoDataToFormData(data:Data,boundary:String,fileName:String) -> Data {
        var fullData = NSMutableData()

        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

        // 4
        fullData.append(data as Data)

        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

//        // 6 - The end. Notice -- at the start and at the end
//        let lineSix = "--" + boundary + "--\r\n"
//        fullData.append(lineSix.data(
//            using: String.Encoding.utf8,
//            allowLossyConversion: false)!)

        return fullData as Data
    }

}

