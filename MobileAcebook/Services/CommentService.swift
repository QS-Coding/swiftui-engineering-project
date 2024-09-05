import Foundation

class CommentService {
    static let shared = CommentService()
    private let baseURL = "http://localhost:3000"
    
    private init() {}

    // Fetch comments for a specific post
    func fetchComments(forPostId postId: String, completion: @escaping ([Comment]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/comments/\(postId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = AuthenticationService.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }
            
            do {
                let comments = try JSONDecoder().decode([Comment].self, from: data)
                completion(comments, nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }
        
        task.resume()
    }
    
    // Create a new comment for a specific post
    func createComment(message: String, forPostId postId: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/comments/\(postId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = AuthenticationService.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = [
            "message": message,
            "createdAt": Date().iso8601String()
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
}
