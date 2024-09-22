//
//  Image_FeedUITests.swift
//  Image FeedUITests
//
//  Created by Гена Утин on 21.09.2024.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
        
    }
    
    func testAuth() throws {
        sleep(10)
        app.buttons.firstMatch.tap()
        
        sleep(5)
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText("_")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        passwordTextField.typeText("_")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuerry = app.tables
        let cell = tablesQuerry.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        cellToLike.buttons["likeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
        
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Nikita Solovev"].exists)
        XCTAssertTrue(app.staticTexts["@utinsstory"].exists)
        
        app.buttons["logoutButton"].tap()
        
        sleep(3)
        app.alerts["Уверены, что хотите выйти?"].scrollViews.otherElements.buttons["Да"].tap()
        
        sleep(5)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
    
}
