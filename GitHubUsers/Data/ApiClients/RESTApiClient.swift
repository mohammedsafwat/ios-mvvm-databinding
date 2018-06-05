//
//  RESTApiClient.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Foundation
import Alamofire

class RESTApiClient: ApiClient {
    var headers: [String : String]
    
    init(headers: [String : String]) {
        self.headers = headers
    }
    
    func performRequest(requestUrlString: String, onSuccess: @escaping ApiClientSuccessCallBack, onError: @escaping ApiClientErrorCallBack) {
        Alamofire.request(requestUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        onSuccess(data)
                    }
                case .failure(let error):
                    onError(error)
                }
        }
    }
}
