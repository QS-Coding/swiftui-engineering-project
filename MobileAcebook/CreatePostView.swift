//
//  CreatePostView.swift
//  MobileAcebook
//
//  Created by Maz on 03/09/2024.
//

import SwiftUI

struct CreatePostView: View {
    @State private var userInput: String = ""
    var body: some View {
        
     
           
        VStack(alignment: .center){
            Text("Make a Post").font(.largeTitle).bold()
            TextField(
                "Post text, lorem ipsum day...",
                text: $userInput,
                axis: .vertical
            ).textFieldStyle(.roundedBorder)
                .lineLimit(10, reservesSpace: true)
                .multilineTextAlignment(.leading)
                .frame(minWidth: 100, maxWidth: 400, minHeight: 100, maxHeight: 250)
//                .cornerRadius(40)
            
            HStack(alignment: .center, spacing: 3){
                Button("Add Image"){}
                    .frame(width: 96, height: 64)
                    .background(Color(red: 0, green: 0.48, blue: 1))
                    .cornerRadius(40)
                    .foregroundColor(.white)
                
                Spacer()
                Button("Create Post"){}
                    .frame(width: 96, height: 64)
                    .background(Color(red: 0, green: 0.48, blue: 1))
                    .cornerRadius(40)
                    .foregroundColor(.white)
                
            }.padding(40)
            
        }.frame(height: 800)
        .padding()
        .background(Color(red: 0, green: 0.96, blue: 1))
        .navigationTitle("Create Post")
        
        
        
    }
    
    
}


#Preview {
    CreatePostView()
}
