//
//  UserRemoteDataSourceSpec.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Quick
import Nimble
@testable import GitHubUsers

class UserRemoteDataSourceSpec: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var returnedUserData: UserData?
        var returnedError: Error?
        var userRemoteDataSource: UserRemoteDataSource?
        
        let apiClient = RESTApiClient(headers: [:])
        let baseUrlString = "https://api.github.com/users/"
        let validUsername = "mohammedsafwat"
        let validUserRequestUrlString = baseUrlString + validUsername
        let stubValidUserData = "StubValidUserData"
        
        describe("user remote data source") {
            beforeEach {
                returnedUserData = nil
                returnedError = nil
                
                userRemoteDataSource = UserRemoteDataSource(apiClient: apiClient, baseUrl: baseUrlString)
            }
            
            context("when fetching user data is successful", {
                beforeEach {
                    self.stub(urlString: validUserRequestUrlString, jsonFileName: stubValidUserData)
                    userRemoteDataSource?.fetchUserData(username: validUsername, onSuccess: { (data) in
                        returnedUserData = data
                    })
                }
                
                it("correctly parses user data", closure: {
                    expect(returnedUserData).toEventuallyNot(beNil(), timeout: 10)
                    expect(returnedUserData?.name).to(equal("Mohammed Safwat"))
                    expect(returnedUserData?.bio).to(equal("Test Bio"))
                    expect(returnedUserData?.email).to(equal("test@email.com"))
                    expect(returnedUserData?.followers).to(equal(1))
                    expect(returnedUserData?.following).to(equal(2))
                })
            })
            
            context("when fetching user data is not successful", {
                let error = NSError(domain: "com.safwat.GitHubUsers", code: 404, userInfo: nil)

                beforeEach {
                    self.stub(urlString: validUserRequestUrlString, error: error)
                    userRemoteDataSource?.fetchUserData(username: validUsername, onError: { (error) in
                        returnedError = error
                    })
                }

                it("returns error", closure: {
                    expect(returnedError).toEventuallyNot(beNil(), timeout: 10)
                    expect(returnedError?.localizedDescription).to(equal(error.localizedDescription))
                })
            })
        }
    }
}
