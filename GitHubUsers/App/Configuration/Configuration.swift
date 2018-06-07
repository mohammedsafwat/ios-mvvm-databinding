//
//  Configuration.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/9/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Foundation
import UIKit

struct Configuration {
    struct UserDataView {
        static let CornerRadius = CGFloat(8.0)
        static let BorderColor = UIColor.lightGray
        static let BorderWidth = CGFloat(1.0)
    }
    
    struct API {
        static let BaseURLString = "https://api.github.com/users/"
    }
    
    struct CoreData {
        static let DataModelName = "GitHubUsers"
    }
}
