//
//  Request.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import Foundation


class FourSquareService: NSObject {
    
    private let request: FourSquareAPI
    var httpMethod: HTTPMethod
    
    public init(request: FourSquareAPI , httpMethod: HTTPMethod = .get) {
        self.request = request
        self.httpMethod = httpMethod
    }
    
    public func performNetworkOperationWithData(completion: @escaping (_ isSuccess: Bool ,_ responseData: Data? ,_ error: Error?) -> Void) {
        
        guard var urlComponents = URLComponents(string: request.relativeURL) else {
            fatalError("URL could not be configured.")
        }
        
        urlComponents.queryItems = request.parameters.map { (name, value) in URLQueryItem(name: name, value: value) }
        
        guard let url = urlComponents.url else {
            fatalError("baseURL could not be configured.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        print(request)
        
        NetworkConnector.networkRequest(with: request) { (data, response, error) in
            if let jsonData = data {
                completion(true, jsonData, nil)
            } else if let requestError = error {
                completion(false, nil, requestError)
            }
        }
    }
}
