//
//  PhotoViewModel.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation
import SwiftUI

class PhotoViewModel: ObservableObject {
    
    @Published var service: Service?
    @Published var listOfPhotoModels = [PhotoModel]()
    @Published var showPhotoList: Bool = false
    
    func getPhotos(linkType: String) {
        
        self.service = Service()
        self.service?.getPhotosFromRemote(linkType: linkType, completion: { listOfPhotos, error in
            print("inside")
            if error != nil {

                print("ERROR: \(String(describing: error?.localizedDescription))")
                // TODO

            }

            if listOfPhotos != nil {
                
                for item in listOfPhotos! {
                    self.listOfPhotoModels.append(item)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                    withAnimation {
                        self.showPhotoList = true
                    }
                }
                
            }
        })
        
    }
}
