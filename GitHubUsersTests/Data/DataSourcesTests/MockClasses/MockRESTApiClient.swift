//
//  MockRESTApiClient.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 6/4/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Foundation
@testable import GitHubUsers

class MockRESTApiClient: RESTApiClient {
    override func performRequest(requestUrlString: String, onSuccess: @escaping ApiClientSuccessCallBack, onError: @escaping ApiClientErrorCallBack) {
        
    }
}
