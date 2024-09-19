//
//  WebViewPresenterSpy.swift
//  Image Feed
//
//  Created by Гена Утин on 18.09.2024.
//

import Image_Feed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewControllerProtocol?
    
    func viewDidload() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
