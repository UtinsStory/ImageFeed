//
//  ProfilePresenterSpy.swift
//  Image Feed
//
//  Created by Гена Утин on 19.09.2024.
//

import Image_Feed
import UIKit

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var isLogoutButtonTapped: Bool = false
    var isViewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
    func logout() {
        isLogoutButtonTapped = true
    }
    
    func getProfile() -> Profile? {
        return nil
    }
    
    func getAvatarUrl() -> URL? {
        return nil
    }
}
