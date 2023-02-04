//
//  PostsViewModel.swift
//  ToothPick
//
//  Created by Jhonny on 2/3/23.
//

import Foundation

/// Protocol for ViewController that owns the viewModel
protocol PostsViewModelProtocol: AnyObject {
    func handleData()
    func handleError()
}

/// ViewModel class for Posts
class PostsViewModel {
    
    /// Delegate
    weak var delegate: PostsViewModelProtocol?
    
    /// Service handler that can handle multiple types of network calls
    let service: PostsServiceable
    
    /// DidSet is needed to update the data once the model is changed
    var posts: [PostsModel] = [] {
        didSet {
            self.updateUI?()
        }
    }
    
    /// Closure
    var updateUI: (() -> Void)?
    
    /// Initilizer
    /// - Parameter service: Type or service can be generic
    init(service: PostsServiceable) {
        self.service = service
    }
    
    /// Delete Post
    /// - Parameter id: id
    private func handlePostDelete(id:Int) {
        posts.remove(at: getIndex(of: id))
    }
    
    /// Update Post
    /// - Parameter newPost: new Post mocked no update from the API
    private func handlePostUpdate(newPost: PostsModel) {
        posts[getIndex(of: newPost.id ?? 0)] = newPost
    }
    
    /// Ceate Post
    /// - Parameter newPost: new Post
    /// inout cannot be used in a BG thread Cannot pass immutable value as inout argument
    private func handlePostCreation(newPost: PostsModel) {
        var post = newPost
        post.canEdit = false
        posts.insert(post, at: 0)
    }
    
    /// Get Index of a certain item based on the ID
    /// - Parameter id: id
    /// - Returns: the current Index
    func getIndex(of id: Int) -> Int {
        guard let index = posts.firstIndex(where: {$0.id == id}) else {
            assertionFailure("Unable to delete")
            return 0
        }
        return index
    }
    
    /// If getPosts API success
    /// - Parameter postsData: Posts model
    func handleSuccessData(postsData: [PostsModel]) {
        self.posts = postsData // for caching
        delegate?.handleData()
    }
}

extension PostsViewModel {
    
    /// Serive fetchPosts
    func fetchPosts() {
        //Needed for Async to not pass it to other functions
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
   
    /// Serive deletePost
   func deletePost(id: Int) {
       //Needed for Async to not pass it to other functions
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
    
    /// Serive updatePost
    func updatePost(post: PostsModel) {
        //Needed for Async to not pass it to other functions
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
    
    /// Serive createPost
    func createPost(post: PostsModel) {
        //Needed for Async to not pass it to other functions
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
