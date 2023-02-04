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
    }    
}

extension PostsViewController: PostsViewModelProtocol {
  
    func handleData() {
        print("handleData")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataSource = PostsDataSource(delegate: self,
                                         posts: self.viewModel.posts)
            self.tableView.delegate = self.dataSource
            self.tableView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
    func handleError() {
        print("handleError")
    }
}

extension PostsViewController: PostsDataSourceDelegate {
    func handleEdit(_ id: Int) {
        print(id)
        print(viewModel.posts.first(where: {$0.id == id})?.title)
    }
    
    func handleDelete(_ id: Int) {
        print(id)
        print(viewModel.posts.first(where: {$0.id == id})?.title)
    }
    
    
}
