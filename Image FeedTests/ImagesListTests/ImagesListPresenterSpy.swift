//
//  ImagesListPresenterSpy.swift
//  Image Feed
//
//  Created by Гена Утин on 20.09.2024.
//

@testable import Image_Feed
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var imagesListService = ImagesListService.shared
    
    var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    var isViewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
    func getCellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return 0
    }
    
    func didTapLike(_ cell: Image_Feed.ImagesListCell, tableView: UITableView) {

    }
    
    func didUpdatePhotos() {
        
    }
    
    
}
