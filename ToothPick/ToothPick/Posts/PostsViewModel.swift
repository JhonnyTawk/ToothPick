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
    
    var posts: [PostsModel] = [] {
        didSet {
            self.updateUI?()
        }
    }
    
    var updateUI: (() -> Void)?
    
    init(service: PostsServiceable) {
        self.service = service
    }
    private func handlePostDelete(id:Int) {
        posts.remove(at: getIndex(of: id))
    }
    
    private func handlePostUpdate(newPost: PostsModel) {
        posts[getIndex(of: newPost.id ?? 0)] = newPost
    }
    
//    inout cannot be used in a BG thread Cannot pass immutable value as inout argument
    private func handlePostCreation(newPost: PostsModel) {
        var post = newPost
        post.canEdit = false
        posts.insert(post, at: 0)
    }
    
    func getIndex(of id: Int) -> Int {
        guard let index = posts.firstIndex(where: {$0.id == id}) else {
            assertionFailure("Unable to delete")
            return 0
        }
        return index
    }
    
    func handleSuccessData(postsData: [PostsModel]) {
        self.posts = postsData // for caching
        delegate?.handleData()
    }
}

extension PostsViewModel {
   
    func fetchPosts() {
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
   
   
   func deletePost(id: Int) {
       Task(priority: .background) {
           let result = await service.deletePost(id: id)
           switch result {
           case .success(_):
               handlePostDelete(id: id)
               break
           case .failure(_):
               delegate?.handleError()
               break
           }
       }
   }
    
    func updatePost(post: PostsModel) {
        Task(priority: .background) {
            let result = await service.updatePost(title: post.title ?? "",
                                                  body: post.body ?? "",
                                                  id: post.id ?? 0)
            switch result {
            case .success(_):
                handlePostUpdate(newPost: post)
                break
            case .failure(_):
                delegate?.handleError()
                break
            }
        }
    }
    
    func createPost(post: PostsModel) {
        Task(priority: .background) {
            let result = await service.createPost(title: post.title ?? "",
                                                  body: post.body ?? "",
                                                  id: post.id ?? 0)
            switch result {
            case .success(_):
                handlePostCreation(newPost: post)
                break
            case .failure(_):
                delegate?.handleError()
                break
            }
        }
    }
}
