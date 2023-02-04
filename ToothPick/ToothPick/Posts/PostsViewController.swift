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
    
    /// Floating Button
    @IBOutlet weak var floatingButton: UIButton!
    
    //Private
    private let viewModel: PostsViewModel
    private var dataSource: PostsDataSource?
    
    
    /// Initializer for the ViewModel
    /// - Parameter viewModel: ViewModel
    init(viewModel: PostsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Used because we are using init and xib
    /// - Parameter coder: coder
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fecth all data
        viewModel.fetchPosts()
        //Bind the view to update The data
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    /// update Floating button once the view is loaded
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.layer.cornerRadius = floatingButton.frame.width / 2
    }
    
    /// Binding Function from ViewModel
    func bindToViewModel() {
        self.viewModel.updateUI = { [weak self] in
            self?.handleData()
        }
    }
    
    /// Create New Post Action
    /// - Parameter sender: UIButton
    @IBAction func createAction(_ sender: Any) {
        BottomSheetHelper.alterPost(viewController: self,
                                   post: nil,
                                   type: .create) { post in
            self.viewModel.createPost(post: post)
        }
    }
}

extension PostsViewController: PostsViewModelProtocol {
    
    /// Load data and pass theen to DataSource
    func handleData() {
        DispatchQueue.main.async {
            self.dataSource = PostsDataSource(delegate: self,
                                              posts: self.viewModel.posts)
            self.tableView.delegate = self.dataSource
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    /// Handle Error
    func handleError() {
        print("handleError")
    }
}

extension PostsViewController: PostsDataSourceDelegate {
    
    /// Delegate Edit to update the post
    /// - Parameter id: Id to check it's better than passing an index
    func handleEdit(_ id: Int) {
                
        let item = viewModel.posts[viewModel.getIndex(of: id)]
        if item.canEdit == false { return }
        // we can use same model as we will not alter the userId/id or we can create a new one
        BottomSheetHelper.alterPost(viewController: self, post: PostsModel(userId: item.userId,
                                                                          id: item.id,
                                                                          title: item.title,
                                                                          body: item.body),
                                   type: .edit) { post in
            self.viewModel.updatePost(post: post)
        }
    }
    
    /// Delegate Delete to remove the post
    /// - Parameter id: Id to check it's better than passing an index
    /// This also can be set in a extension for UIAlertController
    func handleDelete(_ id: Int) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            self.viewModel.deletePost(id: id)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.navigationController?.present(alert, animated: true)
    }
    
    /// DidSelectRow handler to pass to the details View
    /// - Parameter post: Selected Post
    /// Can be used by delegates/ Segues/ or passed data
    func handleRowSelection(_ post: PostsModel) {
        let vc = UIStoryboard.init(name: "Main",
                                   bundle: Bundle.main).instantiateViewController(withIdentifier: "PostsDetailsViewController") as? PostsDetailsViewController
        vc?.post = post
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
