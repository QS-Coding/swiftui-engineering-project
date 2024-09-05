//
//  Comment.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 03/09/2024.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: String
    let message: String   // The text content of the comment
    let createdAt: String   // The creation date of the comment
    let createdBy: User   // The user who created the comment
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"  // Map MongoDB _id to id in Swift
        case message
        case createdAt
        case createdBy
    }
    
//    // Custom initializer to decode the `createdAt` field as a Date from a String
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id = try container.decode(String.self, forKey: .id)
//        message = try container.decode(String.self, forKey: .message)
//        createdBy = try container.decode(User.self, forKey: .createdBy)
//        
//        // Decode `createdAt` as a string and convert it to a `Date`
//        let createdAtString = try container.decode(String.self, forKey: .createdAt)
//        let formatter = ISO8601DateFormatter()
//        if let date = formatter.date(from: createdAtString) {
//            createdAt = date
//        } else {
//            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
//        }
//    }
}
