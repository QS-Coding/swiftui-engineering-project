//
//  User.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//
import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let username: String
    let imgUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id" // Map the MongoDB _id to id in Swift
        case email
        case username
        case imgUrl
    }
}
