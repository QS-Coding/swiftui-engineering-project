import SwiftUI

struct WelcomePageView: View {
    @State private var navigateToLogin = false
    @State private var navigateToSignUp = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Text("Acebook")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
//                Image("ace")

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
                                .frame(width: 177, height: 54)
                                .background(Color.blue)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                        }
                    }

                    // Login Button with NavigationLink
                    NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                        Button(action: {
                            navigateToLogin = true
                        }) {
                            Text("Login")
                                .frame(width: 177, height: 54)
                                .background(Color.blue)
                                .cornerRadius(40)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()

                Spacer()
            }
            .background(Color(red: 0, green: 0.96, blue: 1).ignoresSafeArea())
            .navigationBarHidden(true)  // Hide navigation bar for welcome screen
        }
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
