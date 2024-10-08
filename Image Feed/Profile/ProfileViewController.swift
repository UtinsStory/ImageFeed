//
//  ProfileViewController.swift
//  Image Feed
//
//  Created by Гена Утин on 22.07.2024.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func addProfilePic()
    func addExitButton()
    func addNameLabel()
    func addLoginLabel()
    func addDescriptionLabel()
    func updateAvatar()
    func showAlert(alert: UIAlertController)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    //MARK: - PROPERTIES
    
    var presenter: ProfilePresenterProtocol?
    private var profilePicImageView: UIImageView?
    private var exitButton: UIButton?
    private var nameLabel: UILabel?
    private var loginLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        
//        presenter = ProfilePresenter()
//        presenter?.view = self
        
        presenter?.viewDidLoad()
                
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    //MARK: - METHODS
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func addProfilePic() {
        let profilePicImageView = UIImageView(image: UIImage(named: "profile_pic"))
        profilePicImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePicImageView)
        
        profilePicImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profilePicImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profilePicImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profilePicImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        self.profilePicImageView = profilePicImageView
    }
    
    func addExitButton() {
        let exitButton = UIButton.systemButton(with: UIImage(named: "exit_button")!, target: self, action: #selector(Self.didTapExitButton))
        exitButton.accessibilityIdentifier = "logoutButton"
        exitButton.tintColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6).isActive = true
        
        guard let photo = self.profilePicImageView else {
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
            self.exitButton = exitButton
            return
        }
        exitButton.centerYAnchor.constraint(equalTo: photo.centerYAnchor).isActive = true
        self.exitButton = exitButton
    }
    
    func addNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        guard let photo = self.profilePicImageView else {
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
            self.nameLabel = nameLabel
            return
        }
        nameLabel.firstBaselineAnchor.constraint(equalTo: photo.bottomAnchor, constant: 26).isActive = true
        self.nameLabel = nameLabel
    }
    
    func addLoginLabel() {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        loginLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        guard let name = self.nameLabel else {
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 136).isActive = true
            self.loginLabel = loginLabel
            return
        }
        loginLabel.topAnchor.constraint(equalTo: name.lastBaselineAnchor, constant: 8).isActive = true
        self.loginLabel = loginLabel
    }
    
    func addDescriptionLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        guard let login = self.loginLabel else {
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162).isActive = true
            self.descriptionLabel = descriptionLabel
            return
        }
        descriptionLabel.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 8).isActive = true
        self.descriptionLabel = descriptionLabel
    }
    
    private func updateProfileDetails() {
        guard let profile = presenter?.getProfile() else { return }
        nameLabel?.text = profile.name
        loginLabel?.text = profile.loginname
        descriptionLabel?.text = profile.bio
    }
    
    func updateAvatar() {
        let url = presenter?.getAvatarUrl()
        
        let procesoor = RoundCornerImageProcessor(cornerRadius: 35)
                    |> BlendImageProcessor(blendMode: .normal, backgroundColor: UIColor(named: "YP Black"))
        
        profilePicImageView?.kf.indicatorType = .activity
        profilePicImageView?.kf.setImage(with: url,
                                         placeholder: UIImage(named: "avatar_placeholder"),
                                         options: [.processor(procesoor)]
        )
    }
    
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    @objc
    private func didTapExitButton() {
        presenter?.logout()
    }
}
