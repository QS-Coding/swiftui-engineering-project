//
//  UserService.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 03/09/2024.
//

import Foundation

class UserService {
    static let shared = UserService()
    private let baseURL = "http://localhost:3000"
    
    private init() {}
    
    func createUser(email: String, password: String, username: String, completion: @escaping (User?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password, "username": username]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch let encodingError {
            completion(nil, encodingError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }
        
        task.resume()
    }
    
    func getUserDetails(token: String, completion: @escaping (User?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }
        
        task.resume()
    }
    
    func updateProfilePicture(token: String, imgUrl: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["imgUrl": imgUrl]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch let encodingError {
            completion(false, encodingError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
        
        task.resume()
    }
}

