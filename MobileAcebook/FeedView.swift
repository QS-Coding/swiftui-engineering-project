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
        .background(Color(red: 0, green: 0.48, blue: 1).opacity(0.28))
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

            // Post message on the right side
            Text("\(post.message)")
                .font(Font.custom("SF Pro", size: 17))
                .foregroundColor(.black)
                .frame(width: 135, height: 137, alignment: .topLeading)
                .padding(.leading, 200)

            // Heart icon to show like status
            Image(systemName: checkIfLiked(userId: post.id, post: post) ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(checkIfLiked(userId: post.id, post: post) ? .red : .black)
                .padding(.top, 200)
                .padding(.leading, 200)
        }
        .frame(width: 393, height: 259)
        .background(.white)
        .cornerRadius(48)
        .fullScreenCover(isPresented: $showFullPostView) {
            // Show FullPostView in full screen when triggered
            FullPostView(postId: post.id, token: AuthenticationService.shared.getToken() ?? "")
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
