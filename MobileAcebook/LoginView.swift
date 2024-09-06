import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    @State private var isSignUpViewPresented: Bool = false  // State to trigger SignUpView presentation

    func submit() {
        AuthenticationService.shared.login(email: email.lowercased(), password: password) { success, error in
            if success {
                DispatchQueue.main.async {
                    print("User logged in successfully")
                    isLoggedIn = true
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = error
                }
            }
        }
    }

    var body: some View {
        VStack {
            Text("Login!")
                .font(.system(size: 40, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(width: 288, height: 79, alignment: .center)

            VStack {
                VStack {
                    // Email input field
                    TextField("Enter Email", text: $email)
                        .onChange(of: email) { newValue in
                            email = newValue.lowercased()
                        }
                        .padding(.leading, 16)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color.white.opacity(0.95))
                        .font(.system(size: 17))

                    // Password input field
                    SecureField("Enter Password", text: $password)
                        .padding(.leading, 16)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color.white.opacity(0.95))
                }
                .frame(width: 302, height: 180)
                .cornerRadius(10)

                // Show error message if any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                // Login button
                Button(action: submit) {
                    Text("Login!")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .frame(width: 113, height: 48)
                .background(Color.blue)
                .cornerRadius(40)

                // Sign-up prompt
                Button(action: {
                    isSignUpViewPresented = true
                }) {
                    Text("Don't have an account? Sign up!")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.blue)
                }
                .padding(.top, 10)

                // Navigation to MainView after login
                NavigationLink(destination: MainView(), isActive: $isLoggedIn) {
                    EmptyView()
                }

                // Navigation to SignUpView
                NavigationLink(destination: SignUpView(), isActive: $isSignUpViewPresented) {
                    EmptyView()
                }
            }
            .frame(width: 335, height: 432)
            .background(Color.white.opacity(0.75))
            .cornerRadius(48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0, green: 0.96, blue: 1))
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
