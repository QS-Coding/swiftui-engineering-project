//
//  FeedView.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 04/09/2024.
//

import SwiftUI

struct FeedView: View {
    @State private var posts: [Post] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading posts...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if posts.isEmpty {
                    Text("No posts available.")
                        .padding()
                } else {
                    ScrollView {
                        ForEach(posts) { post in
                            PostCardView(post: post, userId: AuthenticationService.shared.getUserId() ?? "")
                                .padding(.bottom, 10)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Feed")
            .onAppear {
                fetchPosts()
            }
        }
    }

    private func fetchPosts() {
        Task {
            do {
                let fetchedPosts = try await PostService.fetchPosts()
                DispatchQueue.main.async {
                    self.posts = fetchedPosts
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load posts."
                    self.isLoading = false
                }
            }
        }
    }
}


