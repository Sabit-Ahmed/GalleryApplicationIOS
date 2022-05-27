//
//  PhotoViewModel.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation
import SwiftUI

class PhotoViewModel: ObservableObject {
    @Published var appConfig: AppConfig
    @Published var service: Service?
    @Published var listOfPhotoModels = [PhotoModel]()
    @Published var showPhotoList: Bool = false
    @Published var listOfImages = [UIImage]()
    
    init(appConfig: AppConfig) {
        self.appConfig = appConfig
        self.service = Service(appConfig: self.appConfig)
    }
    
    func getApiResponse(linkType: String) {
        
        self.service?.getPhotosFromRemote(linkType: linkType, completion: { listOfPhotos, error in
            print("inside")
            if error != nil {

                print("ERROR: \(String(describing: error?.localizedDescription))")
                // TODO

            }

            if listOfPhotos != nil {
                
                for item in listOfPhotos! {
                    self.listOfPhotoModels.append(item)
                    guard let imageUrl = item.urls?.regular else {
                        return
                    }
                    self.loadImages(urlString: imageUrl)
                }
                
                if !self.showPhotoList {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                        withAnimation {
                            self.showPhotoList = true
                        }
                    }
                }
                
            }
        })
        
    }
    
    func loadImages(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.listOfImages.append(UIImage(data: data) ?? UIImage())
            }
        }
        task.resume()
    }
}
