//
//  PostsServices.swift
//  ToothPick
//
//  Created by Jhonny on 2/4/23.
//

import Foundation


/// PostsServiceable visible functions for the class using the protocol
protocol PostsServiceable {
    func getPosts() async -> Result<[PostsModel], RequestError>
    func deletePost(id:Int) async -> Result<PostsModel, RequestError>
    func updatePost(title: String, body: String, id: Int) async -> Result<PostsModel, RequestError>
    func createPost(title: String, body: String, id: Int) async -> Result<PostsModel, RequestError>
}

struct PostsServices: PostsServiceable {
    
    /// instance of the network Service
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// getPosts()
    /// - Returns: [PostsModel] & RequestError type Error
    func getPosts() async -> Result<[PostsModel], RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.getPosts,
                               responseModel: [PostsModel].self)
    }
    
    /// deletePost()
    /// - Returns: PostsModel & RequestError type Error
    func deletePost(id:Int) async -> Result<PostsModel, RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.deletePost(id: id),
                               responseModel: PostsModel.self)
    }
    
    /// updatePost()
    /// - Returns: PostsModel & RequestError type Error
    func updatePost(title: String, body: String, id: Int) async -> Result<PostsModel, RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.updatePost(id: id, body: body, title: title),responseModel: PostsModel.self)
    }
    
    /// createPost()
    /// - Returns: PostsModel & RequestError type Error
    func createPost(title: String, body: String, id: Int) async -> Result<PostsModel, RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.createPost(id: id, body: body, title: title),responseModel: PostsModel.self)
    }
}
