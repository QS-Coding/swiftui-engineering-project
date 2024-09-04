import Foundation
import SwiftUI

struct Constants {
    static let ColorsBlue: Color = Color(red: 0, green: 0.48, blue: 1)
    static let GraysWhite: Color = .white
}

struct SignUpView: View {
    // State variables for user input and error handling
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?

    // Submit function for signing up
    func submit() {
        AuthenticationService.shared.signUp(username: username, email: email, password: password) { success, error in
            if success {
                // Handle successful sign-up, such as navigating to a new view
                print("User signed up successfully")
            } else {
                // Show error message
                errorMessage = error
            }
        }
    }

    var body: some View {
        VStack {
            Text("Sign Up!")
                .font(.system(size: 40, weight: .bold, design: .default))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(width: 288, height: 79, alignment: .center)
            
            VStack {
                VStack {
                    // Username input
                    TextField("Enter Username", text: $username)
                        .padding(.leading, 16)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color.white.opacity(0.95))
                        .font(Font.custom("SF Pro", size: 17))
                    
                    // Email input
                    TextField("Enter Email", text: $email)
                        .padding(.leading, 16)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color.white.opacity(0.95))
                    
                    // Password input
                    SecureField("Enter Password", text: $password)
                        .padding(.leading, 16)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color.white.opacity(0.95))
                }
                .padding(0)
                .padding(.bottom)
                .frame(width: 302, height: 242, alignment: .center)
                .cornerRadius(10)
                
                // Show error message if any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                // Sign Up button
                HStack(alignment: .center, spacing: 3) {
                    Button(action: submit) {
                        Text("Sign Up!")
                            .font(Font.custom("SF Pro", size: 20))
                            .foregroundColor(Constants.GraysWhite)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .frame(width: 113, height: 48, alignment: .center)
                .background(Constants.ColorsBlue)
                .cornerRadius(40)
                
                // Already have an account? Login prompt
                HStack(alignment: .center, spacing: 0) {
                    Text("Already have an account? Login")
                        .font(Font.custom("SF Pro", size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                        .frame(width: 272, height: 43, alignment: .top)
                }
                .padding(0)
                .frame(width: 272, height: 43, alignment: .center)
            }
            .frame(width: 335, height: 432)
            .background(Color.white.opacity(0.75))
            .cornerRadius(48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0, green: 0.96, blue: 1))
        .statusBar(hidden: false)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
