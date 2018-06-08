//
//  UserDataRepository.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Foundation

class UserDataRepository: UserDataSource {
    private var userRemoteDataSource: UserRemoteDataSource?
    private var userLocalDataSource: UserLocalDataSource?
    var cachedUserData: [String:UserData] = [:]
    var cacheIsDirty: Bool = false
    
    init(userRemoteDataSource: UserRemoteDataSource?, userLocalDataSource: UserLocalDataSource?) {
        self.userRemoteDataSource = userRemoteDataSource
        self.userLocalDataSource = userLocalDataSource
    }
    
    func fetchUserData(username: String, onSuccess: SuccessCallBack?, onError: ErrorCallBack?) {
        if !cachedUserData.isEmpty && !cacheIsDirty {
            if let userData = cachedUserData[username] {
                onSuccess?(userData)
                return
            }
        }
        
        if cacheIsDirty {
            getUserDataFromRemoteDataSource(username: username, onSuccess: { (userData) in
                onSuccess?(userData)
            }) { (error) in
                onError?(error)
            }
        } else {
            userLocalDataSource?.fetchUserData(username: username, onSuccess: { [weak self] (userData) in
                self?.refreshCache(username: username, userData: userData)
                guard let cachedUserData = self?.cachedUserData[username] else { return }
                onSuccess?(cachedUserData)
            }, onError: { [weak self] (error) in
                self?.getUserDataFromRemoteDataSource(username: username, onSuccess: { (userData) in
                    onSuccess?(userData)
                }, onError: { (error) in
                    onError?(error)
                })
            })
        }
    }
    
    func saveUserData(userData: UserData, onError: ErrorCallBack?) {
        userRemoteDataSource?.saveUserData(userData: userData, onError: onError)
        userLocalDataSource?.saveUserData(userData: userData, onError: onError)
        guard let login = userData.login else { return }
        cachedUserData[login] = userData
    }
    
    func deleteUserData(userId: Int, onError: ErrorCallBack?) {
        userRemoteDataSource?.deleteUserData(userId: userId, onError: onError)
        userLocalDataSource?.deleteUserData(userId: userId, onError: onError)
        cachedUserData.removeAll()
    }
    
    func refreshUserData() {
        cacheIsDirty = true
    }
}

extension UserDataRepository {
    private func getUserDataFromRemoteDataSource(username: String, onSuccess: SuccessCallBack?, onError: ErrorCallBack?) {
        userRemoteDataSource?.fetchUserData(username: username, onSuccess: { [weak self] (userData) in
            self?.refreshCache(username: username, userData: userData)
            self?.refreshLocalDataSource(username: username, userData: userData, onError: onError)
            onSuccess?(userData)
        }, onError: { (error) in
            onError?(error)
        })
    }
    
    private func refreshCache(username: String, userData: UserData) {
        cachedUserData[username] = userData
    }
    
    private func refreshLocalDataSource(username: String, userData: UserData, onError: ErrorCallBack?) {
        guard let userId = userData.id else { return }
        userLocalDataSource?.deleteUserData(userId: userId, onError: onError)
        userLocalDataSource?.saveUserData(userData: userData, onError: onError)
    }
}
