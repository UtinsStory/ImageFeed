//
//  AuthViewController.swift
//  Image Feed
//
//  Created by Гена Утин on 28.07.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet private var screenLogoImageView: UIImageView!
    
    @IBOutlet private var loginButton: UIButton!
    
    
    //MARK: - Properties
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
        
    }
    
    
    
    //MARK: IB Actions
    @IBAction func didTapLoginButton() {
        //TODO: Логика работы
    }
    
    
    
    
    
    
    //MARK: - Methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    
    
    
    
}
