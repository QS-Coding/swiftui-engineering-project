//
//  FeedView.swift
//  MobileAcebook
//
//  Created by William Alexander on 04/09/2024.
//

import Foundation
import SwiftUI
func like() -> Void {
    print("liked")
}
var fakeData = [
    Post(id:"1", message: "Just had a great date at the beach ashdbhjasdbcvhasdbfjhbasdhjfbhasdbfjhbasdhjfbdsajhbfjhsdiuhfuihsdauihfoashdufhuhhhhhsdfluihasdlkhfuilahsduhfuahsdfulhaksldhfjkashdfjauskdhfauksldhfuahsdukfhasukdhfukasldhfuhasdkulhfkuasdhfuhasdukflhkaushdfukhasudkfhuklashdfukhasdukfhukasdlhf", createdAt: "Now", createdBy: User(id: "1", email: "test", username: "Will", imgUrl: ""), imgUrl: "", likes: ["1"]),
    Post(id:"2", message: "Test", createdAt: "Now", createdBy: User(id: "1", email: "test", username: "Will", imgUrl: ""), imgUrl: "", likes: ["Will"]),
    Post(id:"3", message: "Test", createdAt: "Now", createdBy: User(id: "1", email: "test", username: "Will", imgUrl: ""), imgUrl: "", likes: ["Will"]),
    Post(id:"4", message: "Test", createdAt: "Now", createdBy: User(id: "1", email: "test", username: "Will", imgUrl: ""), imgUrl: "", likes: ["Will"])
]

func checkIfLiked(userId: String, post: Post) -> Bool {
    if post.likes.contains(userId) {
        return true
    }
    return false
}

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
                    .padding(.trailing, 140)
                Text("\(post.message)")
                    .font(Font.custom("SF Pro", size: 17))
                    .foregroundColor(.black)
                    .frame(width: 135, height: 137, alignment: .topLeading)
                    .padding(.leading, 200)
                Image(systemName: checkIfLiked(userId: post.id, post: post) ? "heart.fill" : "heart" )
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(checkIfLiked(userId: post.id, post: post) ? .red : .black)
                    .padding(.top, 200)
                    .padding(.leading, 200)
                    
                    
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
