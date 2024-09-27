//
//  ProfileTests.swift
//  Image Feed
//
//  Created by Гена Утин on 19.09.2024.
//

import XCTest
@testable import Image_Feed

final class ProfileTests: XCTestCase {
    
    func testViewControllerDidTapLogOut() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        presenter.logout()
        
        //Then
        XCTAssertTrue(presenter.isLogoutButtonTapped)
    }
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
}
