//
//  WebViewControllerSpy.swift
//  Image Feed
//
//  Created by Гена Утин on 18.09.2024.
//
import Image_Feed
import Foundation

final class WebViewControllerSpy: WebViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var loadCalled: Bool = false
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
