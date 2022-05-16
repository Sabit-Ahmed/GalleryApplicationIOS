//
//  PhotoViewModel.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation

class PhotoViewModel: ObservableObject {
    
    @Published var service: Service?
    
    func getPhotos() {
        
        self.service?.getPhotosFromRemote() { response, error in

            if error != nil {

                print("ERROR: \(String(describing: error?.localizedDescription))")
                // TODO

            }

            if response != nil {
                //
            }


        }
        
    }
}
