import SwiftUI

struct FeedView: View {
    @Binding var shouldRefresh: Bool  // Use binding to trigger refresh
    @State private var posts: [Post] = []  // To store the fetched posts
    @State private var isLoading: Bool = true  // To show loading state
    @State private var errorMessage: String?  // To handle and show errors

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading posts...")  // Show loading indicator
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if posts.isEmpty {
                Text("No posts available.")
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 10) {  // Add some spacing between posts
                        // Display the posts in reversed order (newest first)
                        ForEach(posts.reversed()) { post in
                            PostView(post: post)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)  // Extra padding to avoid overlap with the navigation bar
                }
            }
        }
        .onAppear {
            fetchPosts()  // Fetch posts when the view appears
        }
        .onChange(of: shouldRefresh) { newValue in
            if newValue {
                fetchPosts()  // Refetch posts when shouldRefresh is true
                shouldRefresh = false  // Reset the refresh flag
            }
        }
        .background(Color(red: 0, green: 0.96, blue: 1).ignoresSafeArea())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func fetchPosts() {
        Task {
            do {
                let fetchedPosts = try await PostService.fetchPosts()
                DispatchQueue.main.async {
                    print(fetchedPosts)  // Check if posts are being received
                    self.posts = fetchedPosts
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load posts."
                    self.isLoading = false
                    print("Error fetching posts: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct PostView: View {
    let post: Post
    @State private var showFullPostView = false  // State to control showing FullPostView
    @State private var isLiked: Bool = false     // Track the current like status
    @State private var likesCount: Int = 0       // Track the number of likes
    @State private var currentUserId: String = AuthenticationService.shared.getUserId() ?? ""

    var body: some View {
        ZStack {
            // The grey background placeholder or image
            if let imgUrl = post.imgUrl, let url = URL(string: imgUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 192, height: 217)  // Same size as before
                        .cornerRadius(48)
                        .padding(.trailing, 140)  // Image aligned to left with padding
                        .onTapGesture {
                            showFullPostView.toggle()  // Show FullPostView when tapped
                        }
                } placeholder: {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(width: 192, height: 217)
                        .cornerRadius(48)
                        .padding(.trailing, 140)
                        .onTapGesture {
                            showFullPostView.toggle()  // Show FullPostView even if no image is present
                        }
                }
            } else {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: 192, height: 217)
                    .cornerRadius(48)
                    .padding(.trailing, 140)
                    .onTapGesture {
                        showFullPostView.toggle()  // Show FullPostView if no image is present
                    }
            }

            
            VStack(alignment: .leading) {
                            Text("Posted by: \(post.createdBy.username)")
//                                .font(Font.custom("SF Pro Bold", size: 17))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.leading, 220)
                            
                            
                            Text("\(post.message)")
                                .font(Font.custom("SF Pro", size: 17))
                                .foregroundColor(.black)
                                .frame(width: 135, height: 137, alignment: .topLeading)
                                .padding(.leading, 220)
                        }


            HStack(spacing: 20) {
                            Image(systemName: "message")
                                .resizable()
                                .frame(width: 38, height: 38)
                                .opacity(1.8)
                                .onTapGesture {
                                    showFullPostView.toggle()
                                }
                            
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(isLiked ? .red : .black)
                                .onTapGesture {
                                    toggleLike()
                                }
                    }
                    .padding(.top, 180)  // Adjust vertical positioning
                    .padding(.leading, 200)  // Align icons to the right side of the post image
        }
        .frame(width: 393, height: 259)
        .background(.white)
        .cornerRadius(48)
        .onAppear {
            // Set the initial like status and likes count
            isLiked = checkIfLiked(userId: currentUserId, post: post)
            likesCount = post.likes.count
        }
        .fullScreenCover(isPresented: $showFullPostView) {
            FullPostView(postId: post.id, token: AuthenticationService.shared.getToken() ?? "")
        }
    }
    
    // Function to toggle the like state and call the backend
    private func toggleLike() {
        Task {
            // Optimistically toggle the like state
            isLiked.toggle()
            if isLiked {
                likesCount += 1
            } else {
                likesCount -= 1
            }

            do {
                let success = try await PostService.updateLikes(postId: post.id)
                if !success {
                    // Revert the like state if the backend update fails
                    isLiked.toggle()
                    if isLiked {
                        likesCount += 1
                    } else {
                        likesCount -= 1
                    }
                }
            } catch {
                // Handle error and revert like state if needed
                print("Error updating likes: \(error.localizedDescription)")
                isLiked.toggle()
                if isLiked {
                    likesCount += 1
                } else {
                    likesCount -= 1
                }
            }
        }
    }
}

// Helper function to check if a post is liked
func checkIfLiked(userId: String, post: Post) -> Bool {
    return post.likes.contains(userId)
}



struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(shouldRefresh: .constant(false))
    }
}
