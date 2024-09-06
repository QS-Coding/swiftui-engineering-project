import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""  // Adding username field
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isSignUpSuccessful: Bool = false
    @State private var isLoginViewPresented: Bool = false  // State to trigger LoginView presentation

    // Function to handle sign-up
    func submitSignUp() {
        AuthenticationService.shared.signUp(username: username, email: email.lowercased(), password: password) { success, error in  // Ensure email is passed in lowercase
            if success {
                // Navigate to MainView after successful sign-up
                DispatchQueue.main.async {
                    print("User signed up successfully")
                    isSignUpSuccessful = true  // This triggers the NavigationLink
                }
            } else {
                // Show error message
                DispatchQueue.main.async {
                    errorMessage = error
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Text("Sign Up!")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 288, height: 79, alignment: .center)

                VStack {
                    VStack {
                        // Username input field
                        TextField("Enter Username", text: $username)
                            .padding(.leading, 16)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(Color.white.opacity(0.95))
                            .font(Font.custom("SF Pro", size: 17))
                            .cornerRadius(15)

                        // Email input field
                        TextField("Enter Email", text: $email)
                            .onChange(of: email) { newValue in
                                // Force the email text to lowercase
                                email = newValue.lowercased()
                            }
                            .padding(.leading, 16)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(Color.white.opacity(0.95))
                            .font(Font.custom("SF Pro", size: 17))
                            .cornerRadius(15)

                        // Password input field
                        SecureField("Enter Password", text: $password)
                            .padding(.leading, 16)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(15)
                    }
                    .padding(0)
                    .padding(.bottom)
                    .frame(width: 302, height: 240, alignment: .center)
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
                        Button(action: submitSignUp) {
                            Text("Sign Up!")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .frame(width: 113, height: 48, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(40)

                    // Already have an account? Log in prompt
                    HStack(alignment: .center, spacing: 0) {
                        Button(action: {
                            isLoginViewPresented = true  // Trigger LoginView presentation
                        }) {
                            Text("Already have an account? Log in")
                                .font(Font.custom("SF Pro", size: 18))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                                .frame(width: 272, height: 43, alignment: .top)
                        }
                    }
                    .padding(0)
                    .frame(width: 272, height: 43, alignment: .center)

                    // NavigationLink to MainView, activated when signed up
                    NavigationLink(destination: LoginView(), isActive: $isSignUpSuccessful) {
                        EmptyView()
                    }

                    // NavigationLink back to LoginView
                    NavigationLink(destination: LoginView(), isActive: $isLoginViewPresented) {
                        EmptyView()
                    }
                }
                .frame(width: 335, height: 432)
                .background(Color.white.opacity(0.75))
                .cornerRadius(48)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0, green: 0.96, blue: 1))
            .statusBar(hidden: false)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
