//
//  Service.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation

class Service {
    
    var url: URL?
    var request: NSMutableURLRequest?
    var sessionConfiguration: URLSessionConfiguration?
    var session: URLSession?
    var dataTask: URLSessionDataTask?
    
    func getLink(linkType: String) -> String {
        
        let ACCESS_KEY = "gIWX8EWv2qZrSl6Z7wowyy-G0V-S7haMAXre7XWpLz8"
        
        switch linkType.lowercased() {
        case "next": return "https://api.unsplash.com/photos/?client_id=\(ACCESS_KEY)&per_page=12&page=2"
        case "last": return "https://api.unsplash.com/photos/?client_id=\(ACCESS_KEY)&per_page=12&page=26318"
        case "more": return "https://api.unsplash.com/photos/random/?client_id=\(ACCESS_KEY)&count=3"
        default: return "https://api.unsplash.com/photos/random/?client_id=\(ACCESS_KEY)&count=15"
        }
    }
    
    func getResponseFromRemote(linkType: String, completion: @escaping (([ResponseModel]?, Error?) -> Void)) {
        
        let requestUrlString = getLink(linkType: linkType)

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

            self.dataTask = self.session?.dataTask(with: self.request! as URLRequest) { data, response, error in


//                if let httpResponse = response as? HTTPURLResponse {
//                    print(httpResponse.statusCode) // TODO: Handle request timeout by using this code
//                }

                print("Inside dataTask of API")
                // Check if there is any error
                guard error == nil else {
//                    print("ERROR: \(error!.localizedDescription)")
                    // There is error
                    DispatchQueue.main.async {
                        completion(nil, error) // when you have error
                    }
                    return
                }



                // Operate on the fetched data
                do {
                    // Create a json decoder object
                    let jsonDecoder = JSONDecoder()

                    // Decode json
                    let modules = try jsonDecoder.decode([ResponseModel].self, from: data!)
                    
                    
                    
                    DispatchQueue.main.async {
                        completion(modules, nil) // when you have user
                    }


                }
                catch {
                    // Couldn't parse the json data
//                    print(error)

                    DispatchQueue.main.async {
                        self.session?.invalidateAndCancel()
                        completion(nil, error) // when you have error
                    }

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
    
    func getPhotosFromLocal() -> [ResponseModel]? {
        
        // Get a url path to the json file
        let pathString = Bundle.main.path(forResource: "CachedResponse", ofType: "json")

        // Check if the pathString is a nil object. Otherwise,
        guard pathString != nil else {
            return nil
        }

        // Create a url object
        let url = URL(fileURLWithPath: pathString!)
        
        do {
            // Create data object
            let data = try Data(contentsOf: url)
            
            // Operate on the fetched data
            do {
                // Create a json decoder object
                let jsonDecoder = JSONDecoder()
                
                // Decode json
                let modules = try jsonDecoder.decode([ResponseModel].self, from: data)
                return modules
            }
            catch {
                print(error)
            }
            
        }
        catch {
            print("Can't encode json resquest body")
        }
        return nil
    }
}
