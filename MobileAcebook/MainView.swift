//
//  MainView.swift
//  MobileAcebook
//
//  Created by Karina Dawson on 04/09/2024.
//

import SwiftUI

struct MainView: View {
    @State private var isLogoutPopupShowing = false
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
            TabView {
                Button(action: {
                    isLogoutPopupShowing = true // Show the logout confirmation when the button is pressed
                            }) {
                                Image(systemName: "person.slash.fill")
                            }
                .tabItem {
                    Image(systemName: "person.slash.fill")
                    
                }
                CreatePostView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    
                }
                //find a way to refresh
                .tabItem {
                    Image(systemName: "arrow.clockwise")
                    
                }
                
            }
            overlay(
                        isLogoutPopupShowing ?
                            LogoutConfirmationView(isShowing: $isLogoutPopupShowing, onLogout: {
                                // Perform logout action here
                                print("User logged out")
                            }).transition(.opacity) : nil
                    )
        
        }
    }
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
