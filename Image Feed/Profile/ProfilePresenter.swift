//
//  ProfilePresenter.swift
//  Image Feed
//
//  Created by Гена Утин on 18.09.2024.
//

import UIKit
import Kingfisher

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()
    func getProfile() -> Profile?
    func getAvatarUrl() -> URL?
}

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        
        view?.addProfilePic()
        view?.addNameLabel()
        view?.addLoginLabel()
        view?.addDescriptionLabel()
        view?.addExitButton()
    }
    
    func logout() {
        let alert = UIAlertController(title: "Уверены, что хотите выйти?", message: "Оставайтесь!", preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
            if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) {
                window.rootViewController = SplashViewController()
            }
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .default)
        
        alert.addAction(logOutAction)
        alert.addAction(cancelAction)
        alert.preferredAction = cancelAction
        view?.showAlert(alert: alert)
    }
    
    
    func getProfile() -> Profile? {
        guard let profile = ProfileService.shared.profile else {
            return nil
        }
        
        return profile
    }
    
    func getAvatarUrl() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return nil
        }
        
        return url
    }
    
}
