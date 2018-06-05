//
//  UserDataViewModelSpec.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON
@testable import GitHubUsers

class UserDataViewModelSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var viewModel: UserDataViewModel?
        var validMockJSON: JSON?
        var invalidMockJSON: JSON?
        let baseUrlString = "https://api.github.com/users/"
        let validUsername = "mohammedsafwat"
        let invalidUsername = "msabdullatif"
        let stubValidUserData = "StubValidUserData"
        let stubInvalidUserData = "StubInvalidUserData"
        
        describe("user data view model") {
            beforeEach {
                let userDataRepository = UserDataRepository(userRemoteDataSource: UserRemoteDataSource(apiClient: RESTApiClient(headers: [:]), baseUrl: baseUrlString), userLocalDataSource: UserLocalDataSource(coreDataManager: MockCoreDataManager(modelName: "GitHubUsers")))
                viewModel = UserDataViewModel(userDataRepository: userDataRepository)
                validMockJSON = self.stub(jsonFileName: stubValidUserData)
                invalidMockJSON = self.stub(jsonFileName: stubInvalidUserData)
            }
                
            context("when fetch user data is called with valid username", {
                beforeEach {
                    viewModel?.userData = UserData(json: validMockJSON!)
                }
                it("returns non empty name", closure: {
                    expect(viewModel?.name).toEventually(equal("Mohammed Safwat"), timeout: 10)
                })
                it("returns non empty email", closure: {
                    expect(viewModel?.email).toEventually(equal("test@email.com"), timeout: 10)
                })
                it("returns non empty bio", closure: {
                    expect(viewModel?.bio).toEventually(equal("Test Bio"), timeout: 10)
                })
                it("returns non empty avatarUrl", closure: {
                    expect(viewModel?.avatarUrl).toEventually(equal("https://avatars1.githubusercontent.com/u/241657?v=4"), timeout: 10)
                })
                it("returns zero or more followers", closure: {
                    expect(viewModel?.followers).toEventually(contain("Followers: "), timeout: 10)
                })
                it("returns zero or more following", closure: {
                    expect(viewModel?.following).toEventually(contain("Following: "), timeout: 10)
                })
            })
            
            context("when fetch user data is called with invalid useraname", {
                beforeEach {
                    viewModel?.userData = UserData(json: invalidMockJSON!)
                }
                it("returns empty name", closure: {
                    expect(viewModel?.name).toEventually(equal("---"), timeout: 10)
                })
                it("returns empty email", closure: {
                    expect(viewModel?.email).toEventually(equal("---"), timeout: 10)
                })
                it("returns empty bio", closure: {
                    expect(viewModel?.bio).toEventually(equal("---"), timeout: 10)
                })
                it("returns empty avatarUrl", closure: {
                    expect(viewModel?.avatarUrl).toEventually(beEmpty(), timeout: 10)
                })
                it("returns zero followers", closure: {
                    expect(viewModel?.followers).toEventually(equal("Followers: 0"), timeout: 10)
                })
                it("returns zero following", closure: {
                    expect(viewModel?.following).toEventually(equal("Following: 0"), timeout: 10)
                })
            })
            
            context("when user data is nil", closure: {
                it("returns empty name", closure: {
                    expect(viewModel?.name).to(equal("---"))
                })
                it("returns empty email", closure: {
                    expect(viewModel?.email).to(equal("---"))
                })
                it("returns empty bio", closure: {
                    expect(viewModel?.bio).to(equal("---"))
                })
                it("returns empty avatar url", closure: {
                    expect(viewModel?.avatarUrl).to(beEmpty())
                })
                it("returns empty followers", closure: {
                    expect(viewModel?.followers).to(equal("---"))
                })
                it("returns empty following", closure: {
                    expect(viewModel?.following).to(equal("---"))
                })
            })
            
            context("load user data from repository with found username", {
                beforeEach {
                    self.stub(urlString: baseUrlString, jsonFileName: stubValidUserData)
                    viewModel?.fetchUserData(withUsername: validUsername, forceUpdate: true, showLoadingUI: true)
                }
                it("should display activity indicator when loading begins") {
                    expect(viewModel?.dataLoading).to(beTrue())
                }
                it("should hide user view when loading begins") {
                    expect(viewModel?.userViewHidden).to(beTrue())
                }
                it("should hide activity indicator when loading is finished") {
                    expect(viewModel?.dataLoading).toEventually(beFalse(), timeout: 10)
                }
                it("should display user view when loading is finished") {
                    expect(viewModel?.userViewHidden).toEventually(beFalse(), timeout: 10)
                }
                it("should set userData to a valid object") {
                    expect(viewModel?.userData).toEventuallyNot(beNil(), timeout: 10)
                    expect(viewModel?.userData?.name).toEventually(equal("Mohammed Safwat"), timeout: 10)
                }
            })
            
            context("load user data from repository with not found username", {
                beforeEach {
                    self.stub(urlString: baseUrlString, jsonFileName: stubInvalidUserData)
                    viewModel?.fetchUserData(withUsername: invalidUsername, forceUpdate: true, showLoadingUI: true)
                }
                it("should display activity indicator when loading begins") {
                    expect(viewModel?.dataLoading).to(beTrue())
                }
                it("should hide user view when loading begins") {
                    expect(viewModel?.userViewHidden).to(beTrue())
                }
                it("should hide activity indicator when loading is finished") {
                    expect(viewModel?.dataLoading).toEventually(beFalse(), timeout: 10)
                }
                it("should display user view when loading is finished") {
                    expect(viewModel?.userViewHidden).toEventually(beFalse(), timeout: 10)
                }
                it("should set userData object to a valid object with empty properties") {
                    expect(viewModel?.userData).toEventuallyNot(beNil(), timeout: 10)
                    expect(viewModel?.userData?.name).toEventually(beEmpty(), timeout: 10)
                }
            })
            
            context("load user data from repository and get an error", {
                beforeEach {
                    let error = NSError(domain: "com.safwat.githubusers", code: 401, userInfo: ["error":"Username not found"])
                    self.stub(urlString: baseUrlString, error: error)
                    viewModel?.fetchUserData(withUsername: invalidUsername, forceUpdate: true, showLoadingUI: true)
                }
                it("should display activity indicator when loading begins") {
                    expect(viewModel?.dataLoading).to(beTrue())
                }
                it("should hide user view when loading begins") {
                    expect(viewModel?.userViewHidden).to(beTrue())
                }
                it("should hide activity indicator when loading is finished") {
                    expect(viewModel?.dataLoading).toEventually(beFalse(), timeout: 10)
                }
                it("should display user view when loading is finished") {
                    expect(viewModel?.userViewHidden).toEventually(beTrue(), timeout: 10)
                }
                it("should not set any data to userData object") {
                    expect(viewModel?.userData).toEventually(beNil(), timeout: 10)
                }
                it("should set dataLoadingError to a valid error object") {
                    expect(viewModel?.dataLoadingError).toEventuallyNot(beNil(), timeout: 10)
                }
            })
        }
    }
}
