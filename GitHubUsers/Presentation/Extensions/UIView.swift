//
//  UIView.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/9/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import UIKit

extension UIView {
    func setRoundedCorners(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func setBorderColor(borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
    }
    
    func setBorderWidth(borderWidth: CGFloat) {
        self.layer.borderWidth = borderWidth
    }
}
