//
//  CoordinatorMock.swift
//  ToothPick
//
//  Created by Jhonny on 2/3/23.
//

import Foundation
import UIKit

class Coordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let networkService = NetworkService()
        let viewModel = PostsViewModel(networkService: networkService)
        let viewController = PostsViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
}
