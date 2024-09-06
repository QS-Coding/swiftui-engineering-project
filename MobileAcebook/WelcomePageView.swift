import SwiftUI

struct WelcomePageView: View {
    @State private var navigateToLogin = false
    @State private var navigateToSignUp = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Text("Acebook")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

                Text("You are not logged in.\nPlease login or sign up")
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)

                HStack {
                    // Sign Up Button with NavigationLink
                    NavigationLink(destination: SignUpView(), isActive: $navigateToSignUp) {
                        Button(action: {
                            navigateToSignUp = true
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 5)
                        }
                    }

                    // Login Button with NavigationLink
                    NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                        Button(action: {
                            navigateToLogin = true
                        }) {
                            Text("Login")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 5)
                        }
                    }
                }
                .padding()

                Spacer()
            }
            .background(Color.cyan)
            .navigationBarHidden(true)  // Hide navigation bar for welcome screen
        }
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
