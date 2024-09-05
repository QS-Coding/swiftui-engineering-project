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
                let posts = try await PostService.fetchPosts() // Static call
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
        CommentService.shared.fetchComments(forPostId: postId) { [weak self] comments, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    print("Error fetching comments: \(error)")
                    self.hasError = true
                }
                return
            }

            DispatchQueue.main.async {
                self.comments = comments ?? []
                self.hasError = false
            }
        }
    }
    
    func toggleLike(postId: String, token: String) {
        guard post != nil else { return }

        isLiked.toggle()  // Toggle the isLiked state locally

        Task {
            do {
                let success = try await PostService.updateLikes(postId: postId) // Static call
                if !success {
                    DispatchQueue.main.async {
                        self.isLiked.toggle()  // Revert the isLiked state on failure
                    }
                }
            } catch {
                print("Error updating likes: \(error)")
                DispatchQueue.main.async {
                    self.isLiked.toggle()  // Revert the isLiked state on error
                }
            }
        }
    }
}
