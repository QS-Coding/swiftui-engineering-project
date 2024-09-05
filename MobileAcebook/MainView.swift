import SwiftUI

struct MainView: View {
    @State private var isLogoutPopupShowing = false  // Control logout pop-up visibility
    @State private var showCreatePostView = false  // Control showing the Create Post view
    @State private var navigateToWelcome = false   // Handle navigation to WelcomePageView after logout
    @State private var shouldRefreshFeed = false   // Trigger feed refresh

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
            // Show Feed and pass in the refresh control
            FeedView(shouldRefresh: $shouldRefreshFeed)

            VStack {
                Spacer() // Pushes the tab bar to the bottom

                // TabView-style bar
                HStack {
                    Spacer()

                    // Logout Button (Triggers logout popup)
                    Button(action: {
                        isLogoutPopupShowing = true
                    }) {
                        VStack {
                            Image(systemName: "person.slash.fill")
                            Text("Logout")
                        }
                    }
                    Spacer()

                    // Create Post Button (Navigates to Create Post view using fullScreenCover)
                    Button(action: {
                        showCreatePostView = true
                    }) {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Post")
                        }
                    }
                    Spacer()

                    // Refresh Button (Triggers feed refresh)
                    Button(action: {
                        print("Refreshing feed...")
                        shouldRefreshFeed = true  // Set refresh flag to true
                    }) {
                        VStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh")
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
            }
            
            // Show logout confirmation popup
            if isLogoutPopupShowing {
                LogoutConfirmationView(isShowing: $isLogoutPopupShowing, onLogout: {
                    AuthenticationService.shared.logout()  // Perform logout
                    navigateToWelcome = true  // Navigate to WelcomePageView
                })
                .transition(.opacity)
                .animation(.easeInOut, value: isLogoutPopupShowing)
            }
        }
        // Present CreatePostView in a full screen mode without NavigationView
        .fullScreenCover(isPresented: $showCreatePostView) {
            CreatePostView()
        }
        // Navigate to the Welcome screen after logout
        .fullScreenCover(isPresented: $navigateToWelcome) {
            WelcomePageView()  // Assume WelcomePageView exists
        }
        // Ensure the navigation bar is hidden
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
