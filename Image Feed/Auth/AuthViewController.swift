//
//  AuthViewController.swift
//  Image Feed
//
//  Created by Гена Утин on 28.07.2024.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController,
                                    WebViewViewControllerDelegate {
    
    //MARK: - IB Outlets
    @IBOutlet private var screenLogoImageView: UIImageView!
    @IBOutlet private var loginButton: UIButton!
    
    //MARK: - Properties
    
    private let showSWebViewIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2Storage = OAuth2TokenStorage.shared
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSWebViewIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showSWebViewIdentifier)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: IB Actions
    
    @IBAction func didTapLoginButton() {
        //TODO: Реализовать функционал выхода из профиля
    }
    
    //MARK: - Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popToRootViewController(animated: true)
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(withCode: code) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let token):
                oauth2Storage.token = token
                print("Actual token: \(token)")
                self.delegate?.didAuthenticate(self)
            case .failure:
                let alert = UIAlertController(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
