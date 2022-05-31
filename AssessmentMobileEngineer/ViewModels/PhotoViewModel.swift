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
    @Published var responseUrlString: String?
    @Published var responses = [ResponseModel]()
    @Published var showPhotoList: Bool = false
    @Published var listOfImages = [UIImage]()
    @Published var imageCache = ImageCacheManager.getImageCache()

    
    func loadResponses(linkType: String = "default") {
        if loadResponseFromCache() {
            return
        }
        getResponseFromRemote(linkType: linkType)
    }
    
    func loadResponseFromCache() -> Bool {
       
        guard let cacheImage = imageCache.get(forKey: self.responseUrlString!) else {
           return false
       }
       
        DispatchQueue.main.async {
            self.listOfImages.append(cacheImage)
        }
       return true
    }
    
    func getResponseFromRemote(linkType: String) {
        
        self.service = Service()
        self.service?.getResponseFromRemote(linkType: linkType, completion: { responses, error in
            print("inside")
            if error != nil {

                print("ERROR: \(String(describing: error?.localizedDescription))")
                // TODO

            }

            if responses != nil {
                
                for item in responses! {
                    self.responses.append(item)
                    guard let imageUrl = item.urls?.regular else {
                        return
                    }
                    self.loadImage(urlString: imageUrl)
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
    
    func loadImage(urlString: String) {
       if loadImageFromCache(urlString: urlString) {
           return
       }
       getImagesFromReponse(urlString: urlString)
    }
    
    func loadImageFromCache(urlString: String) -> Bool {
       
       guard let cacheImage = imageCache.get(forKey: urlString) else {
           return false
       }
       
        DispatchQueue.main.async {
            self.listOfImages.append(cacheImage)
        }
       return true
    }
    
    func getImagesFromReponse(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.listOfImages.append(UIImage(data: data) ?? UIImage())
                self.imageCache.set(forKey: urlString, image: UIImage(data: data) ?? UIImage())
            }
        }
        task.resume()
    }
}
