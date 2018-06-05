//
//  ImageLoader.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/9/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ImageLoader {
    class func loadImage(imageUrl: String?, into imageView: UIImageView) {
        guard let imageUrl = imageUrl else { return }
        Alamofire.request(imageUrl).responseImage { (response) in
            imageView.image = response.result.value
        }
    }
}
