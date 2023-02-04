//
//  NetworkService.swift
//  ToothPick
//
//  Created by Jhonny on 2/3/23.
//

import Foundation

protocol NetworkServiceProtocol {
//    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchData<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

//The HTTPNetworkService is defined as a struct because it does not need to inherit from any class and does not have any reference type properties
struct NetworkService: NetworkServiceProtocol {
   
    func fetchData<T : Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        guard let url = URL(string: endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        //No headers needed in this API
        
        //check if body exist
        if let body = endpoint.body {
            request.httpBody = stringToJsonData(postBody: body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidURL)
            }
            print(response.statusCode)
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            default:
                return .failure(.errorFailure)
            }
        } catch {
            return .failure(.noResponse)
        }
    }
    
    private func stringToJsonData(postBody: [String: String]) -> Data? {
        if let objectData = try? JSONSerialization.data(withJSONObject: postBody, options: []) {
            return objectData
        }
        return nil
    }
}
