//
//  PostsViewController.swift
//  ToothPick
//
//  Created by Jhonny on 2/3/23.
//

import Foundation
import UIKit

class PostsViewController: UIViewController {
    
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
        
    }
}

extension PostsViewController: PostsViewModelProtocol {
  
    func handleData() {
        print("handleData")
    }
    
    func handleError() {
        print("handleError")
    }
}
