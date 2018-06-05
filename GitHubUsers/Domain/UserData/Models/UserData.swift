//
//  UserData.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import SwiftyJSON

class UserData {
    var login: String?
    var id: Int?
    var name: String?
    var bio: String?
    var email: String?
    var avatarUrl: String?
    var followers: Int?
    var following: Int?
    
    init(json: JSON) {
        login = json["login"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        bio = json["bio"].stringValue
        email = json["email"].stringValue
        avatarUrl = json["avatar_url"].stringValue
        followers = json["followers"].intValue
        following = json["following"].intValue
    }
    
    init(login: String?, id: Int?, name: String?, bio: String?, email: String?, avatarUrl: String?, followers: Int?, following: Int?) {
        self.login = login
        self.id = id
        self.name = name
        self.bio = bio
        self.email = email
        self.avatarUrl = avatarUrl
        self.followers = followers
        self.following = following
    }
}
