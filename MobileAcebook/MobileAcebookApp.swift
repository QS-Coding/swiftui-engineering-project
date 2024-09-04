//
//  MobileAcebookApp.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 30/09/2023.
//

import SwiftUI

@main
struct MobileAcebookApp: App {
    var body: some Scene {
        
        WindowGroup {
            
            WelcomePageView()
            
            
        }
    }
}

struct MobileAcebookApp_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
        
    }
}
