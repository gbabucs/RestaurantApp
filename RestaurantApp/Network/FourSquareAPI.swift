//
//  FourSquareAPI.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import Foundation

struct FourSquareAPIConstant {
    static let clientId = "VSVCY2G2DU4LCXDNLRIFVVLHLHCHDRTWVRNQGCPD4RWDXYZR"
    static let clientSecret = "4RLCN3IBHYI5OUNADVKP4HV3XUFE5XAOYMCDKFZQ1NWINZ1U"
    static let version = "20160810"
    static let locale = "en"
    static let category = "4d4b7105d754a06374d81259"
}

enum FourSquareAPI {
    case recommended(query: SearchParameter)
}

//--------------------------------------------------------------------------
// MARK: - EndPoint
//--------------------------------------------------------------------------

extension FourSquareAPI: EndPoint {
    
    struct Parameter {
        struct Key {
            static let clientID = "client_id"
            static let clientSecret = "client_secret"
            static let version = "v"
            static let category = "categoryId"
            static let location = "ll"
            static let query = "query"
            static let limit = "limit"
            static let radius = "radius"
            static let locale = "locale"
        }
    }
    
    struct Default {
        struct Value {
            static let version = "20160301"
            static let limit = "50"
            static let radius = "2000"
        }
    }
    
    var baseURL: String {
        return "https://api.foursquare.com/v2"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .recommended:
            return "/venues/search"
        }
    }
    
    var relativeURL: String {
        return self.baseURL + self.path
    }
    
    var parameters: [String: String] {
        switch self {
        case .recommended(let query):
            var parameters = [
                Parameter.Key.version: FourSquareAPIConstant.version,
                Parameter.Key.clientID: FourSquareAPIConstant.clientId,
                Parameter.Key.clientSecret: FourSquareAPIConstant.clientSecret,
                Parameter.Key.category: FourSquareAPIConstant.category
            ]
            
            if let coordinate = query.coordinate {
                parameters[Parameter.Key.location] = "\(coordinate.latitude),\(coordinate.longitude)"
            }
            
            
            parameters[Parameter.Key.radius] = Default.Value.radius
        
            parameters[Parameter.Key.limit] = Default.Value.limit
            
            return parameters
        }
    }
}
