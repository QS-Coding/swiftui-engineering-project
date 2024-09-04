import Foundation
import Combine

class FullPostViewModel: ObservableObject {
    @Published var post: Post?
    @Published var comments: [Comment]?
    @Published var isLiked: Bool = false
    @Published var hasError: Bool = false  // Add this property to track errors
    
    func fetchPost(postId: String, token: String) {
        Task {
            do {
                let posts = try await PostService.fetchPosts()
                if let fetchedPost = posts.first(where: { $0.id == postId }) {
                    DispatchQueue.main.async {
                        self.post = fetchedPost
                        self.isLiked = fetchedPost.likes.contains(token)  // Check if user has already liked the post
                        self.hasError = false  // Reset the error state
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hasError = true  // Set error state if no post found
                    }
                }
            } catch {
                print("Error fetching post: \(error)")
                DispatchQueue.main.async {
                    self.hasError = true  // Set error state if there's an error
                }
            }
        }
    }
    
    func fetchComments(postId: String, token: String) {
        // Assuming CommentService is not async yet, but if it is, similar changes as fetchPost can be done.
        CommentService.shared.fetchComments(forPostId: postId, token: token) { [weak self] comments, error in
            guard let self = self else { return }
            if let comments = comments {
                DispatchQueue.main.async {
                    self.comments = comments
                }
            } else if let error = error {
                print("Error fetching comments: \(error)")
            }
        }
    }
    
    func toggleLike(postId: String, token: String) {
        guard post != nil else { return }
        
        // Toggle the isLiked state locally
        isLiked.toggle()
        
        Task {
            do {
                let success = try await PostService.updateLikes(postId: postId, token: token)
                if !success {
                    // Revert the isLiked state on error
                    DispatchQueue.main.async {
                        self.isLiked.toggle()
                    }
                }
            } catch {
                print("Error updating likes: \(error)")
                // Revert the isLiked state on error
                DispatchQueue.main.async {
                    self.isLiked.toggle()
                }
            }
        }
    }
}
