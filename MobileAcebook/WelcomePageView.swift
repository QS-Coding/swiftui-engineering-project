//
//  WelcomePageView.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 30/09/2023.
//

import SwiftUI

struct WelcomePageView: View {
    var body: some View {
            NavigationView {
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
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 5)
                        }
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .foregroundColor(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 5)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .background(Color.cyan)
                .edgesIgnoringSafeArea(.all)
            }
        }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
