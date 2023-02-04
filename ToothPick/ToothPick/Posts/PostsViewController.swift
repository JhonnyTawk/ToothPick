//
//  PostsViewController.swift
//  ToothPick
//
//  Created by Jhonny on 2/3/23.
//

import Foundation
import UIKit

class PostsViewController: UIViewController {
    
    //IBOutltes
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.separatorColor = .white
            tableView.separatorStyle = .singleLine
            tableView.tableFooterView = UIView()
            tableView.register(PostsCell.nib, forCellReuseIdentifier: PostsCell.identifier)
        }
    }
    
    //Private
    private let viewModel: PostsViewModel
    private var dataSource: PostsDataSource?
    
    init(viewModel: PostsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        bindToViewModel()
    }
    
    func bindToViewModel() {
        self.viewModel.updateUI = { [weak self] in
            self?.handleData()
        }
    }
}

extension PostsViewController: PostsViewModelProtocol {
  
    func handleData() {
        DispatchQueue.main.async {
            self.dataSource = PostsDataSource(delegate: self,
                                              posts: self.viewModel.posts)
            self.tableView.delegate = self.dataSource
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
            self.tableView.reloadData()
        }
    }
    func handleError() {
        print("handleError")
    }
}

extension PostsViewController: PostsDataSourceDelegate {
    func handleEdit(_ id: Int) {
        
//        let item = viewModel.posts.first(where: {$0.id == id})
        guard let index = viewModel.posts.firstIndex(where: {$0.id == id}) else {
            assertionFailure("Unable to edit")
            return
        }
        let item = viewModel.posts[index]
        // we can use same model as we will not alter the userId/id or we can create a new one
        BottomSheetHelper.editPost(viewController: self, post: PostsModel(userId: item.userId,
                                                                          id: item.id,
                                                                          title: item.title,
                                                                          body: item.body),
                                   type: .edit) { post in
            
            //done
            self.updateModel(at: index,
                             newPost: post)
        }
    }
    
    func handleDelete(_ id: Int) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            //Handle Delete
            guard let index = self.viewModel.posts.firstIndex(where: {$0.id == id}) else {
                assertionFailure("Unable to delete")
                return
            }
            self.viewModel.posts.remove(at: index)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.navigationController?.present(alert, animated: true)
    }
    
    func updateModel(at index: Int, newPost: PostsModel) {
        viewModel.posts[index] = newPost
    }
}
