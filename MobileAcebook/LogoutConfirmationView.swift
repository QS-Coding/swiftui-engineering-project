//
//  LogoutConfirmationView.swift
//  MobileAcebook
//
//  Created by Sam Quincey on 04/09/2024.
//

import SwiftUI

struct LogoutConfirmationView: View {
    @Binding var isShowing: Bool
    let onLogout: () -> Void
    
    var body: some View {
        VStack {
            Text("Are you sure about logging out?")
                .font(.headline)
                .padding(.top, 20)
            
            Spacer()
            
            HStack {
                Button(action: {
                    // Dismiss the pop-up
                    isShowing = false
                }) {
                    Text("No")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    // Perform the logout action
                    onLogout()
                }) {
                    Text("Log me out")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding([.leading, .trailing, .bottom], 20)
        }
        .frame(width: 300, height: 150)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct LogoutConfirmationView_Previews: PreviewProvider {
    @State static var isShowing = true
    static var previews: some View {
        LogoutConfirmationView(isShowing: $isShowing, onLogout: {
            print("Logged out")
        })
    }
}
