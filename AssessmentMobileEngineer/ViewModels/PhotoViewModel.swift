//
//  PhotoViewModel.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation

class PhotoViewModel: ObservableObject {
    
    @Published var service: Service?
    @Published var listOfPhotoModels: [PhotoModel]?
    
    func getPhotos() {
        print("outside")
        self.service = Service()
        self.service?.getPhotosFromRemote(completion: { listOfPhotos, error in
            print("inside")
            if error != nil {

                print("ERROR: \(String(describing: error?.localizedDescription))")
                // TODO

            }

            if listOfPhotos != nil {
                self.listOfPhotoModels = listOfPhotos
            }
        })
        
    }
}
