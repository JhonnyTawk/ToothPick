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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
