import SwiftUI

struct PostCardView: View {
    let post: Post
    let userId: String  // This is the logged-in user's ID

    @State private var isLiked: Bool
    @State private var likesCount: Int

    init(post: Post, userId: String) {
        self.post = post
        self.userId = userId
        _isLiked = State(initialValue: post.likes.contains(userId))
        _likesCount = State(initialValue: post.likes.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Display the username of the post author directly
            Text("Posted by: \(post.createdBy.username)")  // Directly access post.createdBy.username
                .font(.caption)
                .foregroundColor(.gray)

            // Display image (if any)
            if let imgUrl = post.imgUrl, let url = URL(string: imgUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                        .cornerRadius(10)
                }
            }

            // Display message
            Text(post.message)
                .lineLimit(3)  // Limit the message to prevent the card from being too big
                .truncationMode(.tail)
                .padding(.vertical, 10)

            HStack {
                // Like button and count
                Button(action: toggleLike) {
                    HStack {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .black)
                        Text("\(likesCount)")  // Display the number of likes
                    }
                }
                Spacer()
                // Show when the post was created
                Text(formatDate(post.createdAt))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }

    // Handle like toggling
    private func toggleLike() {
        Task {
            do {
                let success = try await PostService.updateLikes(postId: post.id)
                if success {
                    isLiked.toggle()
                    likesCount += isLiked ? 1 : -1
                }
            } catch {
                print("Error updating likes: \(error)")
            }
        }
    }

    // Helper function to format date string
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}
