//
//  UserLocalDataSource.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import Foundation
import CoreData

class UserLocalDataSource: UserDataSource {
    
    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchUserData(username: String, onSuccess: SuccessCallBack? = nil, onError: ErrorCallBack? = nil) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login = %@", username)
        
        coreDataManager.managedObjectContext().performAndWait {
            do {
                // Execute Fetch Request
                let user = try fetchRequest.execute().first
                guard let id = user?.id, let followers = user?.followers, let following = user?.following else {
                    let error = NSError(domain: "com.safwat.githubusers", code: 401, userInfo: ["Error":"Some of the fetched user data properties are nil"])
                    onError?(error)
                    return
                }
                let userData = UserData(login: user?.login, id: Int(id), name: user?.name, bio: user?.bio, email: user?.email, avatarUrl: user?.avatarUrl, followers: Int(followers), following: Int(following))
                onSuccess?(userData)
            } catch {
                let fetchError = error as NSError
                onError?(fetchError)
            }
        }
    }
    
    func saveUserData(userData: UserData, onError: ErrorCallBack? = nil) {
        coreDataManager.managedObjectContext().performAndWait {
            // Create User Record
            let user = User(context: coreDataManager.managedObjectContext())
            
            // Configure User
            if let userId = userData.id {
                user.id = Int32(userId)
            }
            if let followers = userData.followers {
                user.followers = Int32(followers)
            }
            if let following = userData.following {
                user.following = Int32(following)
            }
            user.login = userData.login
            user.name = userData.name
            user.email = userData.email
            user.bio = userData.bio
            user.avatarUrl = userData.avatarUrl
        }
        
        do {
            try coreDataManager.managedObjectContext().save()
        } catch {
            let saveError = error as NSError
            onError?(saveError)
        }
    }
    
    
    func deleteUserData(userId: Int, onError: ErrorCallBack? = nil) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", userId)
        
        coreDataManager.managedObjectContext().performAndWait {
            do {
                let user = try fetchRequest.execute().first
                if let user = user {
                    coreDataManager.managedObjectContext().delete(user)
                    try coreDataManager.managedObjectContext().save()
                }
            } catch {
                let deleteError = error as NSError
                onError?(deleteError)
            }
        }
    }
    
    func deleteAllUsers(onError: ErrorCallBack? = nil) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        
        coreDataManager.managedObjectContext().performAndWait {
            do {
                if let users = try fetchRequest.execute() as? [User] {
                    for user in users {
                        coreDataManager.managedObjectContext().delete(user)
                    }
                    try coreDataManager.managedObjectContext().save()
                }
            } catch {
                let deleteError = error as NSError
                onError?(deleteError)
            }
        }
    }
    
    func refreshUserData() {
        // Not required because UserDataRepository handles the logic
        // of refreshing the tasks from all available data sources.
    }
}
