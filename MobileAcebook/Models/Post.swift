//
//  Post.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 03/09/2024.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: String
    let message: String
    let createdAt: String
    let createdBy: User
    let imgUrl: String?
    let likes: [String] // List of user IDs who liked the post
}
