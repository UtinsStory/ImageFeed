//
//  SplashViewController.swift
//  Image Feed
//
//  Created by Гена Утин on 31.07.2024.
//

import UIKit
import SwiftKeychainWrapper

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}


final class SplashViewController: UIViewController {
    
    private let showAuthSegueIdentifier = "ShowAuthFlow"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private var splashLogoImageView: UIImageView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token{
            fetchProfile(token)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: .main)
            let navigationController = storyBoard.instantiateViewController(identifier:
                                                                                "NavigationController") as? UINavigationController
            let authViewController = storyBoard.instantiateViewController(identifier:
                                                                            "AuthViewController") as? AuthViewController
            guard let authViewController, let navigationController else { return }
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.isModalInPresentation = true
            navigationController.viewControllers[0] = authViewController
            authViewController.delegate = self
            authViewController.modalPresentationStyle = . fullScreen
            present(navigationController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // УДАЛИТЬ ПЕРЕД СДАЧЕЙ
        KeychainWrapper.standard.removeAllKeys()
        // УДАЛИТЬ ПЕРЕД СДАЧЕЙ
        
        view.backgroundColor = UIColor(named: "YP Black")
        addSplashLogo()
        
    }
    
    private func addSplashLogo() {
        let splashLogoImageView = UIImageView(image: UIImage(named: "splash_screen_logo"))
        splashLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashLogoImageView)
        splashLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        splashLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else {return}
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                self.profileImageService.fetchProfileImageURL(username: profile.usernmane, token: token) { _ in }
            case .failure:
                //Ошибка получения профиля
                break
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
}
