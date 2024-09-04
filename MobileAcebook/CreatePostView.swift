//
//  CreatePostView.swift
//  MobileAcebook
//
//  Created by Maz on 03/09/2024.
//

import SwiftUI

struct CreatePostView: View {
    @State private var userInput: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showDestination: Bool = false
    
    
    func navigateToAllPosts () {
        showDestination = !showDestination
    }
    
    var body: some View {
        
        NavigationView {
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
                    //                Button("Create Post"){
                    //                    Task  {
                    //                        do {
                    //                            let response = try await PostService.createPost(message: userInput, image: nil, token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjZkNWQyODhmMDE3NTQ0MzVhNWQ0OWU1IiwiaWF0IjoxNzI1MzczNTQyLCJleHAiOjE3MjUzNzQxNDJ9.x3JEt9OSUwKhNMvtntpXLqq_L-p2viA7sCTleYfxXDA")
                    //
                    //                            Alert(title: Text("Post Created"), message: Text("Post has been created"), dismissButton: .default(Text("Close")))
                    //                        } catch {
                    //                            Alert(title: Text("Error creating post"), message: Text("Post has been created"), dismissButton: .default(Text("Close")))
                    //                        }
                    //                    }
                    //                }
                    
                    
                    
                    Button("Create Post"){
                        Task {
                            do {
                                _ = try await PostService.createPost(
                                    message: userInput,
                                    image: nil,
                                    token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjZkNWQyODhmMDE3NTQ0MzVhNWQ0OWU1IiwiaWF0IjoxNzI1MzczNTQyLCJleHAiOjE3MjUzNzQxNDJ9.x3JEt9OSUwKhNMvtntpXLqq_L-p2viA7sCTleYfxXDA"
                                )
                                // Update alert properties for a successful post
                                alertTitle = "Post Created"
                                alertMessage = "Your post has been created"
                                showAlert = true
                                
                                
                            } catch {
                                // Update alert properties for an error
                                alertTitle = "Error creating post"
                                alertMessage = "There was an error creating the post."
                                showAlert = true
                            }
                        }
                    }.alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(alertTitle),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("Close"), action:
                                navigateToAllPosts
                            )
                        )
                    }
                    .frame(width: 96, height: 64)
                    .background(Color(red: 0, green: 0.48, blue: 1))
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    
                        NavigationLink(destination: WelcomePageView(), isActive: $showDestination){
                        }
                    
                    
                }.padding(40)
                
            }.frame(maxHeight: 900)
                .padding()
                .background(Color(red: 0, green: 0.96, blue: 1))
            
        }

    }
}



#Preview {
    CreatePostView()
}
