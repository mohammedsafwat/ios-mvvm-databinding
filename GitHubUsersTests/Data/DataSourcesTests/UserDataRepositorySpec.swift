//
//  UserDataRepositorySpec.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 5/30/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Quick
import Nimble
@testable import GitHubUsers

class UserDataRepositorySpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var userDataRepository: UserDataRepository?
        let userRemoteDataSource: MockUserRemoteDataSource = MockUserRemoteDataSource(apiClient: MockRESTApiClient(headers: [:]), baseUrl: "https://api.github.com/users/")
        let userLocalDataSource: MockUserLocalDataSource = MockUserLocalDataSource(coreDataManager: MockCoreDataManager(modelName: "GitHubUsers"))
        
        // Mock User Data
        let login = "testuser"
        let id = 1
        let name = "Test User"
        let bio = "Test Bio"
        let email = "testemail@email.com"
        let avatarUrl = "https://testresources/image.jpg"
        let followers = 10
        let following = 20
        
        let mockUserData = UserData(login: login, id: id, name: name, bio: bio, email: email, avatarUrl: avatarUrl, followers: followers, following: following)

        describe("user data repository") {
            beforeEach {
                userRemoteDataSource.fetchUserDataIsCalled = false
                userLocalDataSource.fetchUserDataIsCalled = false
                userRemoteDataSource.mockUserData = mockUserData
                userLocalDataSource.mockUserData = mockUserData
                userDataRepository = UserDataRepository(userRemoteDataSource: userRemoteDataSource, userLocalDataSource: userLocalDataSource)
            }
            
            context("when fetchUserData is called twice", {
                var fetchedUserData: UserData?

                beforeEach {
                    // Call fetchUserData for the first time.
                    userRemoteDataSource.isDataAvailable = true
                    userDataRepository?.fetchUserData(username: login, onSuccess: { (userData) in
                        fetchedUserData = userData
                    }, onError: nil)
                }

                it("should cache userData after first call to API", closure: {
                    // After calling `fetchUserData` on userDataRepository,
                    // it should call `fetchUserData` on userRemoteDataSource.
                    expect(userRemoteDataSource.fetchUserDataIsCalled).to(beTrue())
                    expect(fetchedUserData?.email).to(equal(mockUserData.email))

                    // Call fetchUserData the second time. It should not call
                    // `fetchUserData` on userRemoteDataSource and just return
                    // the data from the cache.
                    userRemoteDataSource.fetchUserDataIsCalled = false
                    userDataRepository?.fetchUserData(username: login, onSuccess: { (userData) in
                        fetchedUserData = userData
                    }, onError: nil)
                    expect(userRemoteDataSource.fetchUserDataIsCalled).to(beFalse())
                    expect(fetchedUserData?.email).to(equal(mockUserData.email))
                })
            })

            context("when fetchUserData is called", closure: {
                beforeEach {
                    userDataRepository?.fetchUserData(username: login, onSuccess: nil, onError: nil)
                }

                it("should call local data source", closure: {
                    expect(userLocalDataSource.fetchUserDataIsCalled).to(beTrue())
                })
            })
            
            context("when fetchUserData is called and data is not available from remote data source", closure: {
                var fetchedUserData: UserData?
                var fetchError: Error?
                
                beforeEach {
                    userRemoteDataSource.isDataAvailable = false
                    userDataRepository?.fetchUserData(username: login, onSuccess: { (userData) in
                        fetchedUserData = userData
                    }, onError: { (error) in
                        fetchError = error
                    })
                    userDataRepository?.fetchUserData(username: login, onSuccess: nil, onError: nil)
                }
                
                it("should call local data source", closure: {
                    expect(userLocalDataSource.fetchUserDataIsCalled).to(beTrue())
                })
                
                it("should call remote data source", closure: {
                    expect(userRemoteDataSource.fetchUserDataIsCalled).to(beTrue())
                })
                
                it("should return an error", closure: {
                    expect(fetchError).toNot(beNil())
                })
                
                it("should not set any value to the fetchedUserData object", closure: {
                    expect(fetchedUserData).to(beNil())
                })
            })
            
            context("when cache is empty, local data source has data and fetchUserData is called", closure: {
                var fetchedUserData: UserData?
                
                beforeEach {
                    userLocalDataSource.isDataAvailable = true
                    userDataRepository?.fetchUserData(username: login, onSuccess: { (userData) in
                        fetchedUserData = userData
                    }, onError: nil)
                }
                
                it("should fetch data from local data source", closure: {
                    expect(userLocalDataSource.fetchUserDataIsCalled).to(beTrue())
                    expect(userRemoteDataSource.fetchUserDataIsCalled).to(beFalse())
                    expect(fetchedUserData?.email).to(equal(mockUserData.email))
                })
            })
            
            context("when save user data is called", closure: {
                beforeEach {
                    userDataRepository?.saveUserData(userData: mockUserData, onError: nil)
                }
                
                it("should call `saveUserData` on remote and local data sources", closure: {
                    expect(userRemoteDataSource.saveUserDataIsCalled).to(beTrue())
                    expect(userLocalDataSource.saveUserDataIsCalled).to(beTrue())
                })
                
                it("should update the cache after calling `saveUserData`", closure: {
                    expect(userDataRepository?.cachedUserData.keys.count).to(equal(1))
                    expect(userDataRepository?.cachedUserData.keys.first).to(equal(login))
                })
            })
            
            context("when delete user data is called", closure: {
                beforeEach {
                    userDataRepository?.deleteUserData(userId: id, onError: nil)
                }
                
                it("should call `deleteUserData` on remote and local data sources", closure: {
                    expect(userRemoteDataSource.deleteUserDataIsCalled).to(beTrue())
                    expect(userLocalDataSource.deleteUserDataIsCalled).to(beTrue())
                })
                
                it("should clear the cache after calling `deleteUserData`", closure: {
                    expect(userDataRepository?.cachedUserData.count).to(equal(0))
                })
            })
        }
    }
}
