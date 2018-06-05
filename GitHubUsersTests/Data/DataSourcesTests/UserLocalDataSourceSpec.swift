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
            
            context("save a user record and then fetch it", closure: {
                beforeEach {
                    userLocalDataSource?.deleteAllUsers()
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
            
            context("delete user record that exists", closure: {
                beforeEach {
                    userLocalDataSource?.deleteAllUsers()
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

            context("delete a user record that does not exist", closure: {
                beforeEach {
                    userLocalDataSource?.deleteUserData(userId: 1001, onError: { (error) in
                        returnedError = error
                    })
                }

                it("should return an error", closure: {
                    expect(returnedError).toNot(beNil())
                })
            })
        }
    }
}
