//
//  UIAlertUtils.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/9/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import UIKit

class UIAlertUtils {
    class func showAlert(inViewController viewController: UIViewController?, withMessage message: String?) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
}
