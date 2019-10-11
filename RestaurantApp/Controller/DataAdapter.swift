//
//  DataAdapter.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import Foundation

class DataAdapter {
    
    static let shared = DataAdapter()
    
    //--------------------------------------------------------------------------
    // MARK: - Typealias
    //--------------------------------------------------------------------------
    
    typealias GetRecommendedPlaceCompletionHandler = (_ isSuccess: Bool, _ places: BaseModel?) -> Void
    
    //--------------------------------------------------------------------------
    // MARK: - Functions
    //--------------------------------------------------------------------------
    
    func fetchPlaces(query: SearchParameter, completion: @escaping GetRecommendedPlaceCompletionHandler) {
        let service = FourSquareService(request: .recommended(query: query))
        
        fetchData(from: service, type: BaseModel.self, completion: completion)
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Private functions
    //--------------------------------------------------------------------------
    
    private func fetchData<T: Codable>(from request: FourSquareService, type: T.Type , completion: @escaping (_ success: Bool, _ response: T?) -> Void) {
        request.performNetworkOperationWithData { success, response, error in
            let result = self.processData(type: type, response: response)
            
            completion(true, result)
        }
    }
    
    private func processData<T: Codable>(type: T.Type, response: Data?) -> T? {
        var result: T? = nil
        
        if let jsondata = response {
            do {
                let object = try JSONDecoder().decode(T.self, from: jsondata)
                
                result = object
                
            } catch let jsonError {
                print("Error decoding Json Questons", jsonError)
            }
        }
        
        return result
    }
}
