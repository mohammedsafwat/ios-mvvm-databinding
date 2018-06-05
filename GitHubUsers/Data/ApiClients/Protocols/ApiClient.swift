//
//  ApiClient.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Foundation

typealias ApiClientSuccessCallBack = (Data) -> Void
typealias ApiClientErrorCallBack = (Error) -> Void

protocol ApiClient {
    var headers: [String : String] { get set }
    func performRequest(requestUrlString: String, onSuccess: @escaping ApiClientSuccessCallBack, onError: @escaping ApiClientErrorCallBack)
}
