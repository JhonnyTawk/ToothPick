////
////  PostsServices.swift
////  ToothPick
////
////  Created by Jhonny on 2/4/23.
////
//
//import Foundation
//
//protocol PostsServiceable {
//    func getPosts() async -> Result<[PostsModel], RequestError>
//}
//
//struct PostsServices: NetworkServiceProtocol, PostsServiceable {
//
//    func getPosts() async -> Result<[PostsModel], RequestError> {
//        return await fetchData(endpoint: PostsEndpoint.getPosts,
//                               responseModel: [PostsModel].self)
//    }
//}
