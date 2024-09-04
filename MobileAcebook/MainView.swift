import SwiftUI

struct MainView: View {
    @State private var isLogoutPopupShowing = false
    @State private var selectedTab = 1  // Track the selected tab, default to Create Post initially
    @State private var previousTab = 1   // Store the previously selected tab

    init() {
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemBlue
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Logout tab (This tab is now just for triggering logout confirmation)
                Text("Logout Placeholder") // This view won't actually be visible
                    .tabItem {
                        Image(systemName: "person.slash.fill")
                        Text("Logout")
                    }
                    .tag(0)

                // Create Post tab
                CreatePostView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                    }
                    .tag(1)

                // Refresh tab
                Text("Refresh Placeholder")  // Add proper refresh functionality later
                    .tabItem {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh")
                    }
                    .tag(2)
            }
            .onChange(of: selectedTab) { tab in
                if tab == 0 {
                    // If the Logout tab is selected, show the confirmation popup and reset the tab to the previous one
                    isLogoutPopupShowing = true
                    selectedTab = previousTab  // Reset to the previously selected tab to prevent the background change
                } else {
                    previousTab = tab  // Store the last valid tab selection
                }
            }
            
            // Show overlay when isLogoutPopupShowing is true
            if isLogoutPopupShowing {
                LogoutConfirmationView(isShowing: $isLogoutPopupShowing, onLogout: {
                    // Perform logout action here
                    print("User logged out")
                    // Optionally, reset the selected tab after logout
                    selectedTab = 1  // Switch to Create Post tab after logout
                })
                .transition(.opacity)  // Apply opacity transition
                .animation(.easeInOut, value: isLogoutPopupShowing)  // Smooth transition in/out
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
