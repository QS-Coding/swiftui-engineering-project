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
                    onLogout()  // Log out the user and navigate back
                }) {
                    Text("Log me out")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding([.leading, .trailing, .bottom], 20)
        }
        .frame(width: 300, height: 150)
        .background(Color.white.opacity(0.85))
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
