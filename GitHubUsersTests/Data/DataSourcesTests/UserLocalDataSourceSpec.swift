//
//  UserLocalDataSourceSpec.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 6/5/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Quick
import Nimble
@testable import GitHubUsers

class UserLocalDataSourceSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var returnedUserData: UserData?
        var returnedError: Error?
        var userLocalDataSource: UserLocalDataSource?
        
        let mockCoreDataManager = MockCoreDataManager(modelName: "GitHubUsers")
        let mockUserData = UserData(login: "seconduser", id: 2, name: "Second User", bio: "Second User Bio", email: "second@gmail.com", avatarUrl: "https://resourceurl/resource.jpg", followers: 5, following: 10)
        
        describe("user local data source") {
            beforeEach {
                returnedUserData = nil
                returnedError = nil
                
                userLocalDataSource = UserLocalDataSource(coreDataManager: mockCoreDataManager)
                
                // Make sure to clean all saved data before each test runs
                userLocalDataSource?.deleteAllUsers()
            }
            
            context("fetch a user record that does not exist") {
                beforeEach {
                    userLocalDataSource?.fetchUserData(username: "nonexistentusername", onError: { (error) in
                        returnedError = error
                    })
                }
                
                it("should return an error", closure: {
                    expect(returnedError).toEventuallyNot(beNil(), timeout: 2)
                    expect(returnedUserData).toEventually(beNil(), timeout: 2)
                })
            }
            
            context("fetch a user record after saving it", closure: {
                beforeEach {
                    userLocalDataSource?.saveUserData(userData: mockUserData)
                    userLocalDataSource?.fetchUserData(username: mockUserData.login!, onSuccess: { (userData) in
                        returnedUserData = userData
                    })
                }
                
                it("should not return an error if the managedObjectContext successfully adds the record to core data") {
                    expect(returnedError).to(beNil())
                }
                
                it("should return the same record that was saved into core data") {
                    expect(returnedUserData).toEventuallyNot(beNil(), timeout: 2)
                    expect(returnedUserData?.email).toEventually(equal(mockUserData.email), timeout: 2)
                }
            })
            
            context("fetch a user record after deleting it", closure: {
                beforeEach {
                    userLocalDataSource?.saveUserData(userData: mockUserData)
                    userLocalDataSource?.deleteUserData(userId: mockUserData.id!)
                    userLocalDataSource?.fetchUserData(username: mockUserData.login!, onSuccess: { (userData) in
                        returnedUserData = userData
                    })
                }

                it("should not return any user record", closure: {
                    expect(returnedUserData).toEventually(beNil(), timeout: 2)
                })
            })
        }
    }
}
