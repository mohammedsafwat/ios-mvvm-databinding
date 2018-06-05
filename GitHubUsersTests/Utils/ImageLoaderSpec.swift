//
//  ImageLoaderSpec.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 5/30/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Quick
import Nimble
@testable import GitHubUsers

class ImageLoaderSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var imageView: UIImageView?
        let validImageUrl = "https://png.icons8.com/ios/1600/home.png"
        let invalidImageUrl = "$54545"
        
        describe("image loader") {
            beforeEach {
                imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat(100), height: CGFloat(100))))
            }
            
            context("load image with non nil valid url", {
                it("should set a non nil image to the image view", closure: {
                    ImageLoader.loadImage(imageUrl: validImageUrl, into: imageView!)
                    expect(imageView?.image).toEventuallyNot(beNil(), timeout: 10)
                })
            })
            
            context("load image with non nil invalid url", {
                it("should set a nil image to the image view", closure: {
                    ImageLoader.loadImage(imageUrl: invalidImageUrl, into: imageView!)
                    expect(imageView?.image).toEventually(beNil(), timeout: 10)
                })
            })
            
            context("load image with nil url", closure: {
                it("should not set any image to the image view", closure: {
                    ImageLoader.loadImage(imageUrl: nil, into: imageView!)
                    expect(imageView?.image).to(beNil())
                })
            })
        }
    }
}

