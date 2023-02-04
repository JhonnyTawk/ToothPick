//
//  PostsDetailsViewController.swift
//  ToothPick
//
//  Created by Jhonny on 2/4/23.
//

import UIKit

class PostsDetailsViewController: UIViewController {

    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            descriptionLabel.numberOfLines = isExpanded ? 0 : 2
            readMoreButton.setTitle(isExpanded ? "Hide" : "Read More", for: .normal)
        }
    }
    
    var post: PostsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = post?.title
        descriptionLabel.text = post?.body
    }
    
    @IBAction func readMoreAction(_ sender: Any) {
        isExpanded = !isExpanded
    }
}
