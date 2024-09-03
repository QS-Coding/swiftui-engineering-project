//
//  Comment.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 03/09/2024.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: String        // Corresponds to the MongoDB ObjectId for the comment
    let message: String   // The text content of the comment
    let createdAt: Date   // The creation date of the comment
    let createdBy: User   // The user who created the comment
}
