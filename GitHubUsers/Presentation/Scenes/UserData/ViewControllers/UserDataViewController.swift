//
//  UserDataViewController.swift
//  GitHubUsers
//
//  Created by Mohammed Safwat on 5/9/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import UIKit

class UserDataViewController: UIViewController {

    @IBOutlet weak var searchInputTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userDataView: UIView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    lazy var userDataViewModel: UserDataViewModel = {
        let apiClient = RESTApiClient(headers: [:])
        let userRemoteDataSource = UserRemoteDataSource(apiClient: apiClient, baseUrl: Configuration.API
            .BaseURLString)
        let userLocalDataSource = UserLocalDataSource(coreDataManager: CoreDataManager(modelName: Configuration.CoreData.DataModelName))
        let userDataRepository = UserDataRepository(userRemoteDataSource: userRemoteDataSource, userLocalDataSource: userLocalDataSource)
       return UserDataViewModel(userDataRepository: userDataRepository)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIBinding()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchInputTextField.resignFirstResponder()
    }
}

extension UserDataViewController {
    private func setupUI() {
        searchInputTextField.text = "Search for GitHub users"
        searchInputTextField.delegate = self
        userDataView.setRoundedCorners(cornerRadius: Configuration.UserDataView.CornerRadius)
        userDataView.setBorderColor(borderColor: Configuration.UserDataView.BorderColor)
        userDataView.setBorderWidth(borderWidth: Configuration.UserDataView.BorderWidth)
        userDataView.isHidden = true
        activityIndicator.isHidden = true
    }
    
    private func setupUIBinding() {
        userDataViewModel.reloadView = { [unowned self] in
            self.populateUIElements()
        }
        
        userDataViewModel.showErrorMessage = { [unowned self] (errorMessage) in
            UIAlertUtils.showAlert(inViewController: self, withMessage: errorMessage)
        }
        
        userDataViewModel.updateLoadingStatus = { [unowned self] (dataLoading) in
            if dataLoading {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
        
        userDataViewModel.updateUserViewHiddenStatus = { [unowned self] (hidden) in
            self.userDataView.isHidden = hidden
        }
    }
    
    private func populateUIElements() {
        ImageLoader.loadImage(imageUrl: userDataViewModel.avatarUrl, into: userAvatarImageView)
        nameLabel.text = userDataViewModel.name
        bioLabel.text = userDataViewModel.bio
        emailLabel.text = userDataViewModel.email
        followersLabel.text = userDataViewModel.followers
        followingLabel.text = userDataViewModel.following
    }
    
    private func fetchUserData(withUsername username: String) {
        userDataViewModel.fetchUserData(withUsername: username, forceUpdate: true, showLoadingUI: true)
        searchInputTextField.resignFirstResponder()
    }
}

extension UserDataViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFieldText = textField.text else { return true }
        fetchUserData(withUsername: textFieldText)
        return true
    }
}
