//
//  Extensions+UIButton.swift
//  ToothPick
//
//  Created by Jhonny on 2/4/23.
//

import Foundation
import UIKit

extension UIButton {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
