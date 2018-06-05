//
//  UserRemoteDataSource.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import SwiftyJSON

class UserRemoteDataSource: UserDataSource {
    private var apiClient: ApiClient
    private var baseUrl: String
    
    init(apiClient: ApiClient, baseUrl: String) {
        self.apiClient = apiClient
        self.baseUrl = baseUrl
    }
    
    func fetchUserData(username: String, onSuccess: SuccessCallBack? = nil, onError: ErrorCallBack? = nil) {
        let requestUrlString = baseUrl + username
        apiClient.performRequest(requestUrlString: requestUrlString, onSuccess: { (data) in
            let json = JSON(data)
            let userData = UserData(json: json)
            onSuccess?(userData)
        }) { (error) in
            onError?(error)
        }
    }
    
    func saveUserData(userData: UserData, onError: ErrorCallBack?) {
        // Not required for now as we don't have an API endpoint to save the user data remotely.
    }
    
    func deleteUserData(userId: Int, onError: ErrorCallBack?) {
        // Not required for now as we don't have an API endpoint to delete the user data remotely.
    }
    
    func refreshUserData() {
        // Not required because UserDataRepository handles the logic
        // of refreshing the tasks from all available data sources.
    }
}
