//
//  PostsServices.swift
//  ToothPick
//
//  Created by Jhonny on 2/4/23.
//

import Foundation

protocol PostsServiceable {
    func getPosts() async -> Result<[PostsModel], RequestError>
}

struct PostsServices: PostsServiceable {

    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPosts() async -> Result<[PostsModel], RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.getPosts,
                               responseModel: [PostsModel].self)
    }
}
