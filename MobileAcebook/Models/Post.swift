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
    let createdBy: User // The user data associated with the post
    let imgUrl: String?
    let likes: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"  // Map MongoDB _id to id in Swift
        case message
        case createdAt
        case createdBy
        case imgUrl
        case likes
    }
}

