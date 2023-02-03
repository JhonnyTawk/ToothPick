//
//  PostsViewModel.swift
//  ToothPick
//
//  Created by Jhonny on 2/3/23.
//

import Foundation

protocol PostsViewModelProtocol: AnyObject {
    func handleData()
    func handleError()
}

class PostsViewModel {
   
    weak var delegate: PostsViewModelProtocol?
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func getPostsService() async -> Result<[PostsModel], RequestError> {
        return await networkService.fetchData(endpoint: PostsEndpoint.getPosts,
                                              responseModel: [PostsModel].self)
    }
    
    private func fetchPosts() async {
        let result = await getPostsService()
        switch result {
        case .success(let posts):
            // handle success
            delegate?.handleData()
            break
        case .failure(let error):
            // handle failure
            delegate?.handleError()
            break
        }
    }
}
