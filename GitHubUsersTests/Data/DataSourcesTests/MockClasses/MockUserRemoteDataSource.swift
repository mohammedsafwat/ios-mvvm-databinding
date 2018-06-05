//
//  MockUserRemoteDataSource.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 6/4/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Foundation
@testable import GitHubUsers

class MockUserRemoteDataSource: UserRemoteDataSource {
    var isDataAvailable: Bool = false
    var mockUserData: UserData?
    var fetchUserDataIsCalled: Bool = false
    var saveUserDataIsCalled: Bool = false
    var deleteUserDataIsCalled: Bool = false
    var refreshUserDataIsCalled: Bool = false
    
    override func fetchUserData(username: String, onSuccess: SuccessCallBack?, onError: ErrorCallBack?) {
        fetchUserDataIsCalled = true
        
        if isDataAvailable {
            onSuccess?(mockUserData!)
        } else {
            let error = NSError(domain: "com.safwat.GitHubUsers", code: 401, userInfo: nil)
            onError?(error)
        }
    }
    
    override func saveUserData(userData: UserData, onError: ErrorCallBack?) {
        saveUserDataIsCalled = true
    }
    
    override func deleteUserData(userId: Int, onError: ErrorCallBack?) {
        deleteUserDataIsCalled = true
    }
    
    override func refreshUserData() {
        refreshUserDataIsCalled = true
    }
}
