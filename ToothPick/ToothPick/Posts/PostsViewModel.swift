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
    let service: PostsServices
    
//    init(networkService: NetworkService) {
//        self.networkService = networkService
//    }
    
    init(service: PostsServices) {
        self.service = service
    }
    
     func fetchData() {
         Task(priority: .background) {
             let result = await service.getPosts()
             switch result {
             case .success(let posts):
                 print(posts)
                 delegate?.handleData()
                 break
             case .failure(let error):
                 print(error)
                 delegate?.handleError()
                 break
             }
         }
       }
}
