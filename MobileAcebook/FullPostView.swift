//
//  FullPostView.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 03/09/2024.
//
import SwiftUI

struct FullPostView: View {
    @StateObject private var viewModel = FullPostViewModel()
    let postId: String
    let token: String
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.hasError {
                        mockPostView
                    } else if let post = viewModel.post {
                        // Display the image and message...
                        if let imageUrl = post.imgUrl {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            }
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 200)
                                .cornerRadius(10)
                        }
                        
                        Text(post.message)
                            .font(.body)
                            .padding(.horizontal)
                        
                        // Like Button for a real post
                        likeButton(isMock: false)
                        
                        Divider()
                        
                        // Comments Section
                        Text("Comments")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if let comments = viewModel.comments {
                            ForEach(comments) { comment in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(comment.createdBy.username)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(comment.message)
                                        .font(.body)
                                    Divider()
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("No comments yet.")
                                .padding(.horizontal)
                        }
                    } else {
                        // Loading state (Optional)
                        Text("Loading...")
                            .padding(.horizontal)
                    }
                }
            }
            
            // Add Comment Button
            HStack {
                Spacer()
                Button(action: {
                    // Handle adding a comment (e.g., show a sheet or navigate to a new view)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.blue)
                }
                Spacer().frame(width: 20)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchPost(postId: postId, token: token)
            viewModel.fetchComments(postId: postId, token: token)
        }
    }
    
    // Mock Post View
    private var mockPostView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 16)
            
            Text("This is a mock post. The original post could not be loaded.")
                .font(.body)
                .padding(.horizontal)
            
            // Like Button for the mock post
            likeButton(isMock: true)
            
            Divider()
                .padding(.horizontal)
            
            // Mock Comments Section
            Text("Comments")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("This is a mock comment.")
                    .font(.body)
                Divider()
                Text("This is another mock comment.")
                    .font(.body)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    // Like Button logic based on whether it's a mock post or real post
    @ViewBuilder
    private func likeButton(isMock: Bool) -> some View {
        HStack {
            Spacer()
            Button(action: {
                if isMock {
                    // Toggle like for mock, no server update
                    viewModel.isLiked.toggle()
                } else {
                    // Toggle like for real post, send server update
                    viewModel.toggleLike(postId: postId, token: token)
                }
            }) {
                HStack(alignment: .center, spacing: 3) {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(viewModel.isLiked ? .red : .black)
                    Text(viewModel.isLiked ? "Liked" : "Like")
                        .font(.body)
                        .foregroundColor(viewModel.isLiked ? .red : .black)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .frame(height: 44, alignment: .center)  // Fixed height to prevent resizing
                .background(Color.clear) // Transparent background
                .cornerRadius(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(viewModel.isLiked ? Color.red : Color.black, lineWidth: 2) // Add border to maintain button shape
                )
            }
            Spacer().frame(width: 20)
        }
        .padding(.horizontal)
    }
}
    struct FullPostView_Previews: PreviewProvider {
        static var previews: some View {
            FullPostView(postId: "examplePostId", token: "exampleToken")
        }
    }


