//
//  AssessmentMobileEngineerApp.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI

@main
struct AssessmentMobileEngineerApp: App {
    
    let appConfig: AppConfig = AppConfig(appName: "AssessmentMobileEngineer", appFlavor: "dev")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PhotoViewModel(appConfig: self.appConfig))
        }
    }
}
