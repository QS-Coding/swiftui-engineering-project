//
//  User.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//
import Foundation

struct User: Codable, Identifiable {
    let email: String
    let username: String
    let imgUrl: String?
}
