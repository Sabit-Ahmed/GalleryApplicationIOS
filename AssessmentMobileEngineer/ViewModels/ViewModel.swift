//
//  Service.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation
import Combine
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var appConfig: AppConfig
    @Published var showPhotoList: Bool = false
    @Published var responseUrlString: String?
    @Published var responses = [ResponseModel]()
    @Published var listOfImages = [UIImage]()
    @Published var imageCache = ImageCacheManager.getImageCache()
    
    private var url: URL?
    private var request: NSMutableURLRequest?
    private var sessionConfiguration: URLSessionConfiguration?
    private var session: URLSession?
    private var dataTask: URLSessionDataTask?
    
    init(appConfig: AppConfig, linkType: String = "default") {
        self.appConfig = appConfig
        if let data = self.readResponseDataFromDisk() {
            self.decodeResponseData(responseData: data)
        }
        else {
            self.getResponseFromRemote(linkType: linkType)
        }
    }
    
    func getLink(linkType: String) -> String {
        
        let ACCESS_KEY = "gIWX8EWv2qZrSl6Z7wowyy-G0V-S7haMAXre7XWpLz8"
        
        switch linkType.lowercased() {
        case "next": return "/photos/?client_id=\(ACCESS_KEY)&per_page=12&page=2"
        case "last": return "/photos/?client_id=\(ACCESS_KEY)&per_page=12&page=26318"
        case "more": return "/photos/random/?client_id=\(ACCESS_KEY)&count=3"
        default: return "/photos/random/?client_id=\(ACCESS_KEY)&count=15"
        }
    }
    
    func getResponseFromRemote(linkType: String) {
        
        let baseApiUrl = CommonUtils.getBaseUrl(appFlavor: self.appConfig.getAppFlavor())
        let urlTypeWithExtension = getLink(linkType: linkType)
        let requestUrlString = baseApiUrl.getResponse + urlTypeWithExtension

        // Create url object
        self.url = URL(string: requestUrlString)

        guard self.url != nil else {
            // Handle if the url can't be created
            return
        }

        do {
            // Create url request object
            self.request = NSMutableURLRequest(url: self.url!)

            // Request method
            self.request?.httpMethod = "GET"
            self.request?.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData

            // Set HTTP Request Headers
            self.request?.setValue("application/json", forHTTPHeaderField: "Accept")
            self.request?.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Get configuration for URL Session
            self.sessionConfiguration = URLSessionConfiguration.default
            self.sessionConfiguration?.timeoutIntervalForResource = 30

            if #available(iOS 11, *) {
                self.sessionConfiguration?.waitsForConnectivity = true
            }

            // Get the session and kick-off task
            self.session = URLSession(configuration: self.sessionConfiguration ?? URLSessionConfiguration.default)

            guard self.request != nil else {
                // Handle if the url can't be created
                return
            }

            self.dataTask = self.session?.dataTask(with: self.request! as URLRequest) { (data, response, error) in

                print("Inside dataTask of API")
                // Check if there is any error
                guard let _:Data = data, let _:URLResponse = response, error == nil else {
                    if error != nil {
                        print("Error inside the dataTask:: \(String(describing: error))")
                    }
                    return
                }
                DispatchQueue.main.async {
//                    self.saveResponseDataToDisk(responseData: data!)
                    self.decodeResponseData(responseData: data!)
                }
            }

            // Kick off the task
            self.dataTask?.resume()

        }
    }
    
    func saveResponseDataToDisk(responseData: Data) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("CachedResponse.json")
            try responseData.write(to: fileURL, options: .atomic)
        } catch { }
    }
    
    func readResponseDataFromDisk() -> Data? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("CachedResponse.json").path
        if FileManager.default.fileExists(atPath: filePath), let data = FileManager.default.contents(atPath: filePath) {
            return data
        }
        return nil
    }
    
    func decodeResponseData(responseData: Data) {
    
        // Operate on the fetched data
        do {
            // Create a json decoder object
            let jsonDecoder = JSONDecoder()

            // Decode json
            let module = try jsonDecoder.decode([ResponseModel].self, from: responseData)
            
            guard !module.isEmpty else { return }
            for item in module {
                self.responses.append(item)
                
                guard let imageUrl = item.urls?.regular else {
                    return
                }
                self.loadImage(urlString: imageUrl)
            }
            DispatchQueue.main.async {
                self.showPhotoList = true
            }
            let jsonData = try JSONEncoder().encode(self.responses)
            self.saveResponseDataToDisk(responseData: jsonData)
        }
        catch {
            // Couldn't parse the json data
            print(error)
            self.session?.invalidateAndCancel()
        }
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
