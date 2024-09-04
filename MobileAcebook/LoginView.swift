//
//  LoginView.swift
//  MobileAcebook
//
//  Created by William Alexander on 03/09/2024.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false

    // Submit function for logging in
    func submit() {
        AuthenticationService.shared.login(email: email, password: password) { success, error in
            if success {
                // Save JWT and navigate to FeedView
                DispatchQueue.main.async {
                    print("User logged in successfully")
                    isLoggedIn = true  // This triggers the NavigationLink
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
        NavigationView {
            VStack {
                Text("Login!")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 288, height: 79, alignment: .center)
                
                VStack {
                    VStack {
                        // Email input field
                        TextField("Enter Email", text: $email)
                            .padding(.leading, 16)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(.white.opacity(0.95))
                            .font(Font.custom("SF Pro", size: 17))
                        
                        // Password input field
                        SecureField("Enter Password", text: $password)
                            .padding(.leading, 16)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(.white.opacity(0.95))
                    }
                    .padding(0)
                    .padding(.bottom)
                    .frame(width: 302, height: 180, alignment: .center)
                    .cornerRadius(10)
                    
                    // Show error message if any
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    // Login button
                    HStack(alignment: .center, spacing: 3) {
                        Button(action: submit) {
                            Text("Login!")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(Constants.GraysWhite)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .frame(width: 113, height: 48, alignment: .center)
                    .background(Constants.ColorsBlue)
                    .cornerRadius(40)
                    
                    // Don't have an account? Sign up prompt
                    HStack(alignment: .center, spacing: 0) {
                        Text("Don't have an account? \nSign up!")
                            .font(Font.custom("SF Pro", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                            .frame(width: 272, height: 43, alignment: .top)
                    }
                    .padding(0)
                    .frame(width: 272, height: 43, alignment: .center)
                    
                    // NavigationLink to FeedView, activated when logged in
                    NavigationLink(destination: FeedView(), isActive: $isLoggedIn) {
                        EmptyView() // NavigationLink will trigger programmatically
                    }
                }
                .frame(width: 335, height: 432)
                .background(.white.opacity(0.75))
                .cornerRadius(48)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0, green: 0.96, blue: 1))
            .statusBar(hidden: false)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
