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
    let service: PostsServiceable
    
    var posts = [PostsModel]()
//    init(networkService: NetworkService) {
//        self.networkService = networkService
//    }
    
    init(service: PostsServiceable) {
        self.service = service
    }
    
     func fetchData() {
         Task(priority: .background) {
             let result = await service.getPosts()
             switch result {
             case .success(let posts):
                 handleSuccessData(postsData: posts)
                 break
             case .failure(let error):
                 print(error)
                 delegate?.handleError()
                 break
             }
         }
     }
    func handleSuccessData(postsData: [PostsModel]) {
        print(posts)
        self.posts = postsData // for caching
        delegate?.handleData()
    }
}
