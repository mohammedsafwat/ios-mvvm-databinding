//
//  UserDataViewModel.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import UIKit

class UserDataViewModel {
    private var userDataRepository: UserDataRepository?
    
    var userData: UserData? {
        didSet {
            reloadView?()
        }
    }
    
    var dataLoadingError: Error? {
        didSet {
            showErrorMessage?(dataLoadingError?.localizedDescription)
        }
    }
    
    var dataLoading: Bool = false {
        didSet {
            updateLoadingStatus?(dataLoading)
        }
    }
    
    var userViewHidden: Bool = true {
        didSet {
            updateUserViewHiddenStatus?(userViewHidden)
        }
    }
    
    var avatarUrl: String {
        // TODO: Return a url for a default avatar
        guard let avatarUrl = userData?.avatarUrl else { return "" }
        return avatarUrl
    }
    
    var name: String {
        guard let name = userData?.name else { return "---" }
        return name.isEmpty ? "---" : name
    }
    
    var bio: String {
        guard let bio = userData?.bio else { return "---" }
        return bio.isEmpty ? "---" : bio
    }
    
    var email: String {
        guard let email = userData?.email else { return "---" }
        return email.isEmpty ? "---" : email
    }
    
    var followers: String {
        guard let followers = userData?.followers else { return "---" }
        return String(format: "Followers: %d", followers)
    }
    
    var following: String {
        guard let following = userData?.following else { return "---" }
        return String(format: "Following: %d", following)
    }
    
    var reloadView: (() -> Void)?
    var showErrorMessage: ((String?) -> Void)?
    var updateLoadingStatus: ((Bool) -> Void)?
    var updateUserViewHiddenStatus: ((Bool) -> Void)?
    
    init(userDataRepository: UserDataRepository?) {
        self.userDataRepository = userDataRepository
    }
    
    func fetchUserData(withUsername username: String, forceUpdate: Bool, showLoadingUI: Bool) {
        if showLoadingUI {
            dataLoading = true
        }
        if forceUpdate {
            userDataRepository?.refreshUserData()
        }
        userViewHidden = true
        
        userDataRepository?.fetchUserData(username: username, onSuccess: { [weak self] (userData) in
            self?.userData = userData
            self?.dataLoading = false
            self?.userViewHidden = false
        }, onError: { [weak self] (error) in
            self?.dataLoadingError = error
            self?.dataLoading = false
            self?.userViewHidden = true
        })
    }
}
