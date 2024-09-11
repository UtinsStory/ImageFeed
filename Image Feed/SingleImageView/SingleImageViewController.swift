//
//  SingleImageViewController.swift
//  Image Feed
//
//  Created by Гена Утин on 23.07.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var photo: Photo?
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBAction private func didTapBackwardButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton() {
        guard let image = imageView.image else { return }
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        imageView.bounds.size = image.size
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func setImage(_ photo: Photo) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: URL(string: photo.largeImageURL)) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {return}
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                print("[SingleImageViewController]:[setImage]: Error getting single image")
                self.showError(photo)
            }
        }
        imageView.frame.size = photo.size
    }
    
    private func showError(_ photo: Photo) {
        let alert = UIAlertController(title: "Что-то пошло не так.",
                                      message: "Попробовать еще раз?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel)
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.setImage(photo)
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let photo else {return}
        setImage(photo)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
