import SwiftUI

struct FullPostView: View {
    @StateObject private var viewModel = FullPostViewModel()
    let postId: String
    let token: String
    
    @State private var commentText: String = ""  // To store the new comment text
    @State private var isAddingComment = false  // To track comment submission
    @State private var submissionError: Bool = false  // Handle errors during comment submission
    
    @Environment(\.dismiss) private var dismiss  // For dismissing the view

    var body: some View {
        VStack {
            // Dismiss button
            HStack {
                Button(action: {
                    dismiss()  // Close the view when tapped
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                }
                Spacer()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.hasError {
                        mockPostView  // If there's an error, show the mock post
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
            
            // Add Comment Section
            VStack {
                HStack {
                    TextField("Add a comment...", text: $commentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 44)
                        .padding(.horizontal)
                    
                    Button(action: {
                        if !commentText.isEmpty {
                            isAddingComment = true
                            submissionError = false  // Reset any previous submission error
                            CommentService.shared.createComment(message: commentText, forPostId: postId) { success, error in
                                if success {
                                    // Comment added successfully, now refresh the comments
                                    viewModel.fetchComments(postId: postId, token: token)
                                    commentText = ""  // Clear the text field
                                } else {
                                    // Handle error during comment submission
                                    submissionError = true
                                }
                                isAddingComment = false
                            }
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.blue)
                    }
                    .disabled(isAddingComment)  // Disable button when adding comment
                    .padding(.trailing)
                }
                .padding(.horizontal)
                
                // Show error message if comment submission fails
                if submissionError {
                    Text("Failed to submit comment. Please try again.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Fetch the post and comments when the view appears
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
                    
                    // Show the number of likes
                    Text("\(viewModel.post?.likes.count ?? 0)")
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

