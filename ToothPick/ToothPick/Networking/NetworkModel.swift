//
//  NetworkModel.swift
//  ToothPick
//
//  Created by Jhonny on 2/3/23.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: RequestMethod { get }
    var body: [String: String]? { get }
}

enum RequestError: Error {
    case decode
    case invalidURL
    case errorFailure
    case noResponse
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "invalidURL"
        default: return "Error"
        }
    }
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
