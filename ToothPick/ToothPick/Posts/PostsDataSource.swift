//
//  PostsDataSource.swift
//  ToothPick
//
//  Created by Jhonny on 2/4/23.
//

import Foundation
import UIKit

protocol PostsDataSourceDelegate: AnyObject {
    func handleEdit(_ id: Int)
    func handleDelete(_ id: Int)
}

class PostsDataSource: NSObject {
    
    weak var delegate: PostsDataSourceDelegate?
    private var posts: [PostsModel]
    
    init(delegate: PostsDataSourceDelegate, posts: [PostsModel]) {
        self.delegate = delegate
        self.posts = posts
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PostsDataSource: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsCell.identifier, for: indexPath) as? PostsCell else {
            return UITableViewCell()
        }
        
        let item = posts[indexPath.row]
        cell.titleLabel.text = item.title
        cell.descLabel.text = item.body
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = posts[indexPath.row]
        
        let delete = UIContextualAction(style: .normal,
                                      title: nil) { [weak self] (action, view, completionHandler) in
            self?.delegate?.handleDelete(item.id ?? 0)
          completionHandler(true)
      }
        delete.backgroundColor = .redColor
        delete.image = UIImage(named: "ic_trash")
        
        let edit = UIContextualAction(style: .normal,
                                      title: nil) { [weak self] (action, view, completionHandler) in
            self?.delegate?.handleEdit(item.id ?? 0)
            completionHandler(true)
      }
        edit.backgroundColor = .greenColor
        edit.image = UIImage(named: "ic_edit")
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        //This will prevent the first action from running when someone does a full swipe.
        config.performsFirstActionWithFullSwipe = false
        return config
    }

    // for iOS 11 and lower to deactivate the delete Action on swipe
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}
