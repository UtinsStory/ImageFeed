//
//  WebViewViewControllerDelegate.swift
//  Image Feed
//
//  Created by Гена Утин on 30.07.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
