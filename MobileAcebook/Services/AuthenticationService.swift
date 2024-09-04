import Foundation

class AuthenticationService {
    static let shared = AuthenticationService()
    
    private let baseURL = "http://localhost:3000"
    
    private init() {}

    // "Local Storage" and Authentication frontend
    
    private let jwtTokenKey = "jwtToken"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: jwtTokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: jwtTokenKey)
    }
    
    func isLoggedIn() -> Bool {
        return getToken() != nil
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: jwtTokenKey)
    }
    
    // Login
    
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/authentication") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            completion(false, "Error encoding login details")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Login error: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, "No data received")
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String {
                    self.saveToken(token)
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, "Invalid login response")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, "Error parsing response")
                }
            }
        }.resume()
    }
    
    // Sign Up
    
    func signUp(username: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            completion(false, "Error encoding sign-up details")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Sign-up error: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, "No data received")
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? String, message.contains("created") {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, "Invalid sign-up response")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, "Error parsing response")
                }
            }
        }.resume()
    }
}
