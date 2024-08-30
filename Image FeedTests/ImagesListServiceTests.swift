//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by Гена Утин on 29.08.2024.
//
@testable import Image_Feed
import XCTest

final class ImagesListServiceTests: XCTestCase {

    func testFetchPhotos() {
        let service = ImagesListService.shared
            let expectation = self.expectation(description: "Wait for Notification")
            NotificationCenter.default.addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { _ in
                    expectation.fulfill()
                }
            
            service.fetchPhotosNextPage()
            wait(for: [expectation], timeout: 10)
            
            XCTAssertEqual(service.photos.count, 10)
        }


}
