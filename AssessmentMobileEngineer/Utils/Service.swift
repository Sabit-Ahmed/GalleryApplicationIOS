//
//  Service.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation

class Service {
    
    var url: URL?
    var request: URLRequest?
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
    
    func getPhotosFromRemote(linkType: String, completion: @escaping (([PhotoModel]?, Error?) -> Void)) {
        
        let requestUrlString = getLink(linkType: linkType)

        // Create url object
        self.url = URL(string: requestUrlString)

        guard self.url != nil else {
            // Handle if the url can't be created
            return
        }

        do {
            // Create url request object
            self.request = URLRequest(url: self.url!)

            // Request method
            self.request?.httpMethod = "GET"

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

            self.dataTask = self.session?.dataTask(with: self.request!) { data, response, error in


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
                    let modules = try jsonDecoder.decode([PhotoModel].self, from: data!)
                    
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
    
    func getPhotosFromLocal() -> [PhotoModel]? {
        
        let YOUR_ACCESS_KEY = "gIWX8EWv2qZrSl6Z7wowyy-G0V-S7haMAXre7XWpLz8"
        let requestUrlString = "https://api.unsplash.com/photos/?client_id=" + YOUR_ACCESS_KEY
        
        // Get a url path to the json file
        let pathString = Bundle.main.path(forResource: requestUrlString, ofType: "json")

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
                let modules = try jsonDecoder.decode([PhotoModel].self, from: data)
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
