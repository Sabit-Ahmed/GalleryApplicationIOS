//
//  AppConfig.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 23/5/22.
//

import Foundation

class AppConfig {
    private let appName: String
    private let appFlavor: String
    
    required init(appName: String, appFlavor: String) {
        self.appName = appName
        self.appFlavor = appFlavor
    }
    
    func getAppName() -> String { return self.appName }
    func getAppFlavor() -> String { return self.appFlavor }
}
