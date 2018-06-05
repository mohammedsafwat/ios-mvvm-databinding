//
//  UserDataSource.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Foundation

typealias SuccessCallBack = (UserData) -> Void
typealias ErrorCallBack = (Error?) -> Void

protocol UserDataSource {
    func fetchUserData(username: String, onSuccess: SuccessCallBack?, onError: ErrorCallBack?)
    func saveUserData(userData: UserData, onError: ErrorCallBack?)
    func deleteUserData(userId: Int, onError: ErrorCallBack?)
    func refreshUserData()
}
