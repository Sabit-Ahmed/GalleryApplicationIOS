//
//  CommonUtils.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 27/5/22.
//

import Foundation

class CommonUtils {
    
    static func getBaseUrl(appFlavor: String) -> APiUrl {
        
        var apiUrl: APiUrl {
            switch appFlavor.lowercased() {
            case "dev": return APiUrl(
                getResponse: "https://api.unsplash.com"  // Modify it and use for dev
            )
                
            case "stg": return APiUrl(
                getResponse: "https://api.unsplash.com"  // Modify it and use for stg
            )
            
            case "prod": return APiUrl(
                getResponse: "https://api.unsplash.com"  // Modify it and use for prod
            )
            
            default: return APiUrl(
                getResponse: "https://api.unsplash.com"  // Modify it and use for default
            )
            }
            
        }
        return apiUrl
    }
    
}
