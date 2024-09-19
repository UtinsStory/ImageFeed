//
//  Untitled.swift
//  Image Feed
//
//  Created by Гена Утин on 19.09.2024.
//

import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func getCellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat
    func didTapLike(_ cell: ImagesListCell, tableView: UITableView)
    func didUpdatePhotos()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    let imagesListService = ImagesListService.shared
    
    func getCellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        let photo = imagesListService.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func didTapLike(_ cell: ImagesListCell, tableView: UITableView) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = imagesListService.photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
            case .failure:
                let alert = UIAlertController(title: "Что-то пошло не так(",
                                              message: "Попробуйте ещё раз позже",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.view?.showAlert(alert: alert)
            }
        }
    }
    
    func didUpdatePhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableViewAnimated(indexPaths)
        }
    }
    
}


