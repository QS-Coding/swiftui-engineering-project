import UIKit
import Foundation

class PostService {
    static let shared = PostService()
    private static let baseURL = "http://localhost:3000"
    
    private init() {}

    // Fetch all posts
   static func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "\(baseURL)/posts") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        if let token = AuthenticationService.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let posts = try JSONDecoder().decode([Post].self, from: data)
        return posts
    }
    
    // Create a new post with optional image
    static func createPost(message: String, image: UIImage?) async throws -> Bool {
        if let image = image {
            // If the user selected an image, upload it to Cloudinary first
            let url = try await uploadImageToCloudinary(image: image)
            // After getting the image URL, create the post with the image
            return try await createPostWithImage(message: message, imgUrl: url)
        } else {
            // If no image was selected, create the post without an image
            return try await createPostWithImage(message: message, imgUrl: nil)
        }
    }
    
    // Helper function to create post with or without image URL
    static private func createPostWithImage(message: String, imgUrl: String?) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/posts") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = AuthenticationService.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = [
            "message": message,
            "imgUrl": imgUrl ?? NSNull()
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    // Upload image to Cloudinary
    static private func uploadImageToCloudinary(image: UIImage) async throws -> String {
        guard let cloudName = Bundle.main.object(forInfoDictionaryKey: "CLOUDINARY_CLOUD_NAME") as? String,
              let uploadPreset = Bundle.main.object(forInfoDictionaryKey: "CLOUDINARY_UPLOAD_PRESET") as? String else {
            throw NSError(domain: "CloudinaryError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cloudinary credentials not found."])
        }
        
        let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(uploadPreset)\r\n".data(using: .utf8)!)
        
        if let imageData = image.jpegData(compressionQuality: 0.7) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
           let url = json["secure_url"] as? String {
            return url
        } else {
            throw NSError(domain: "CloudinaryError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image."])
        }
    }
    
    // Update likes for a post
    static func updateLikes(postId: String) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/posts/\(postId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = AuthenticationService.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = ["postId": postId]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
}
