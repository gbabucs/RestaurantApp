//
//  EndPoint.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import Foundation

protocol EndPoint {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var relativeURL: String { get }
    var parameters: [String: String] { get }
}
