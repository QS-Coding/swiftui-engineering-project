//
//  FeedView.swift
//  MobileAcebook
//
//  Created by William Alexander on 04/09/2024.
//

import Foundation
import SwiftUI

var fakeData = [
    Post(id:"1", message: "Test", createdAt: "Now", createdBy: User(id: "1", email: "test", username: "Will", imgUrl: ""), imgUrl: "", likes: ["Will"]),
    Post(id:"1", message: "Test", createdAt: "Now", createdBy: User(id: "1", email: "test", username: "Will", imgUrl: ""), imgUrl: "", likes: ["Will"]),
    Post(id:"1", message: "Test", createdAt: "Now", createdBy: User(id: "1", email: "test", username: "Will", imgUrl: ""), imgUrl: "", likes: ["Will"]),
    Post(id:"1", message: "Test", createdAt: "Now", createdBy: User(id: "1", email: "test", username: "Will", imgUrl: ""), imgUrl: "", likes: ["Will"])
]



struct PostView: View {
    let post: Post
    
    var body: some View {
        NavigationLink (destination: FullPostView(postId: post.id, token: "example token")){
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 192, height: 217)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .cornerRadius(48)
                Text("\(post.message)")
                    .font(Font.custom("SF Pro", size: 17))
                    .foregroundColor(.black)
                    .frame(width: 135, height: 137, alignment: .topLeading)
                HStack(alignment: .center, spacing: 3) {
                    Text("􀊴")
                        .font(Font.custom("SF Pro", size: 48))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 53, height: 56, alignment: .center)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(red: 0, green: 0.48, blue: 1).opacity(0))
                
                .cornerRadius(40)
            }
            
            
            .frame(width: 393, height: 259)
            .background(.white)
            .cornerRadius(48)
        }
    }
}

struct FeedView: View {
    var body: some View{
        NavigationView{
            ScrollView {
                // Post Card
                ForEach(fakeData) {
                    post in
                    PostView(post: post)
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0, green: 0.48, blue: 1).opacity(0.28))
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
