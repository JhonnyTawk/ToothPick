//
//  PostsCell.swift
//  ToothPick
//
//  Created by Jhonny on 2/4/23.
//

import Foundation
import UIKit

class PostsCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    @IBOutlet weak var descLabel: UILabel! {
        didSet {
            descLabel.numberOfLines = 0
            descLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
