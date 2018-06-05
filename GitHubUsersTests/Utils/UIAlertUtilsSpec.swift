//
//  UIAlertUtilsSpec.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 5/30/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Quick
import Nimble
@testable import GitHubUsers

class UIAlertUtilsSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var viewController: UIViewController?
        
        describe("UI alert utils") {
            context("show alert in view controlelr", {
                beforeEach {
                    viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? UserDataViewController
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                }
                
                it("should display an alert in view controller") {
                    UIAlertUtils.showAlert(inViewController: viewController, withMessage: "Test Message")
                    expect(viewController?.presentedViewController?.isKind(of: UIAlertController.self)).to(beTrue())
                    expect(viewController?.presentedViewController?.title).to(equal("Alert"))
                }
            })
        }
    }
}
