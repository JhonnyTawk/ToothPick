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
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorColor = .white
            tableView.separatorStyle = .singleLine
            tableView.tableFooterView = UIView()
            tableView.register(PostsCell.nib, forCellReuseIdentifier: PostsCell.identifier)
        }
    }
    
    //Private
    private let viewModel: PostsViewModel

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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleError() {
        print("handleError")
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension PostsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsCell.identifier, for: indexPath) as? PostsCell else {
            return UITableViewCell()
        }

        cell.titleLabel.text = viewModel.posts[indexPath.row].title
        cell.descLabel.text = viewModel.posts[indexPath.row].body
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal,
                                        title: nil) { [weak self] (action, view, completionHandler) in
                                            self?.handleEdit()
                                            completionHandler(true)
        }
        edit.backgroundColor = .redColor
        edit.image = UIImage(named: "ic_edit")
        
        let config = UISwipeActionsConfiguration(actions: [edit])
        //This will prevent the first action from running when someone does a full swipe.
        config.performsFirstActionWithFullSwipe = false

        return config

    }
    
    // for iOS 11 and lower to deactivate the delete Action on swipe
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func handleEdit() {
        print("edit")
    }

}
