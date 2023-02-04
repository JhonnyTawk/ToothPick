//
//  PostsServices.swift
//  ToothPick
//
//  Created by Jhonny on 2/4/23.
//

import Foundation

protocol PostsServiceable {
    func getPosts() async -> Result<[PostsModel], RequestError>
    func deletePost(id:Int) async -> Result<PostsModel, RequestError>
    func updatePost(title: String, body: String, id: Int) async -> Result<PostsModel, RequestError>
    func createPost(title: String, body: String, id: Int) async -> Result<PostsModel, RequestError>
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
    
    func deletePost(id:Int) async -> Result<PostsModel, RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.deletePost(id: id),
                               responseModel: PostsModel.self)
    }
    
    func updatePost(title: String, body: String, id: Int) async -> Result<PostsModel, RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.updatePost(id: id, body: body, title: title),responseModel: PostsModel.self)
    }
    
    func createPost(title: String, body: String, id: Int) async -> Result<PostsModel, RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.createPost(id: id, body: body, title: title),responseModel: PostsModel.self)
    }
}
