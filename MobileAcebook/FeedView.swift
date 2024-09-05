import SwiftUI

struct FeedView: View {
    @State private var posts: [Post] = []  // To store the fetched posts
    @State private var isLoading: Bool = true  // To show loading state
    @State private var errorMessage: String?  // To handle and show errors
    let token = AuthenticationService.shared.getToken()
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
                    // Display the posts using PostView
                    ForEach(posts) { post in
                        NavigationLink (destination: FullPostView(postId: post.id, token: token!)){
                            PostView(post: post)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            fetchPosts()  // Fetch posts when the view appears
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

#Preview {
    FeedView()
}


struct PostView: View {
    let post: Post
    
    var body: some View {
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
    }
}

// Helper function to check if a post is liked
func checkIfLiked(userId: String, post: Post) -> Bool {
    return post.likes.contains(userId)
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
