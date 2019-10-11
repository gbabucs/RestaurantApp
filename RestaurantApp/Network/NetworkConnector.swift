//
//  NetworkConnector.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import Foundation

class NetworkConnector: NSObject {
    
    class func networkRequest(with request: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, urlResponse, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    completion(nil, nil ,error)
                } else if let data = data {
                    completion(data, urlResponse, nil)
                }
            }
        }
        task.resume()
    }
}
