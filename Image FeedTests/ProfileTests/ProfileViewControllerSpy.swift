//
//  ProfileViewControllerSpy.swift
//  Image Feed
//
//  Created by Гена Утин on 19.09.2024.
//

import Image_Feed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var didCallAddExitButton: Bool = false
    
    func addProfilePic() {}
    
    func addExitButton() {}
    
    func addNameLabel() {}
    
    func addLoginLabel() {}
    
    func addDescriptionLabel() {}
    
    func updateAvatar() {}
    
    func showAlert(alert: UIAlertController) {}
    
    
}
