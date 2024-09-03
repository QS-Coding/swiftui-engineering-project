//
//  PostService.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 03/09/2024.
//
import UIKit
import Foundation

class PostService {
    static let shared = PostService()
    private let baseURL = "http://localhost:3000"
    
    private init() {}
    
    // Fetch all posts
    func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(posts, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }
        
        task.resume()
    }
    
    // Create a new post with optional image
    func createPost(message: String, image: UIImage?, token: String, completion: @escaping (Bool, Error?) -> Void) {
        if let image = image {
            // If the user selected an image, upload it to Cloudinary first
            uploadImageToCloudinary(image: image) { url, error in
                if let url = url {
                    // After getting the image URL, create the post with the image
                    self.createPostWithImage(message: message, imgUrl: url, token: token, completion: completion)
                } else {
                    completion(false, error)
                }
            }
        } else {
            // If no image was selected, create the post without an image
            self.createPostWithImage(message: message, imgUrl: nil, token: token, completion: completion)
        }
    }
    
    // Helper function to create post with or without image URL
    private func createPostWithImage(message: String, imgUrl: String?, token: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Assuming `token` contains the user ID or you have access to the user's ID
        var body: [String: Any] = [
            "message": message,
            "createdBy": token,  // Assuming token is the user ID, replace if necessary
            "imgUrl": imgUrl ?? NSNull()
        ]
        
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
    
    // Upload image to Cloudinary
    private func uploadImageToCloudinary(image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let cloudName = Bundle.main.object(forInfoDictionaryKey: "CLOUDINARY_CLOUD_NAME") as? String,
              let uploadPreset = Bundle.main.object(forInfoDictionaryKey: "CLOUDINARY_UPLOAD_PRESET") as? String else {
            completion(nil, NSError(domain: "CloudinaryError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cloudinary credentials not found."]))
            return
        }
        
        let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add your unsigned Cloudinary preset
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(uploadPreset)\r\n".data(using: .utf8)!)
        
        // Add image data
        if let imageData = image.jpegData(compressionQuality: 0.7) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let url = json["secure_url"] as? String {
                    completion(url, nil)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }

    // Update likes for a post
    func updateLikes(postId: String, token: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["postId": postId]
        
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


