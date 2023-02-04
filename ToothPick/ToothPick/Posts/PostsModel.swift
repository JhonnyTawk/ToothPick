//
//  PostsModel.swift
//  ToothPick
//
//  Created by Jhonny on 2/3/23.
//

import Foundation

struct PostsModel: Decodable {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
}

enum PostsEndpoint {
    case getPosts
    case getPost(id: Int)
    case createPost(userId: Int, body: String, title: String)
    case updatePost(id:Int, body: String, title: String)
    case deletePost(id:Int)
}

extension PostsEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .getPosts, .createPost:
            return "https://jsonplaceholder.typicode.com/posts"
        case .getPost(let id), .updatePost(let id,_,_), .deletePost(let id):
            return "https://jsonplaceholder.typicode.com/posts/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getPosts, .getPost(_):
            return .get
        case .createPost(_,_,_):
            return .post
        case .updatePost(_,_,_):
            return .put
        case .deletePost(_):
            return .delete
        }
        
    }
    
    // This also can be done on the service level struct/class
    var body: [String : String]? {
        switch self {
        case .updatePost(let userId, let body, let title),
                .createPost(let userId, let body, let title):
            return ["userId":"\(userId)",
                    "body": body,
                    "title": title]
        default:
            return nil
        }
    }
}
