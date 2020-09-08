//
//  PhotoCell.swift
//  UnsplashClone
//
//  Created by Khoa Pham on 9/7/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: NSObject {
  func photoCell(
    _ cell: PhotoCell,
    downloadedImage: UIImage, index: Int)
}

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    var imageUrl: String?
    var index: Int?
//    var imageDownloader: ImageDownloader?
    weak var delegate: PhotoCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
//        imageDownloader?.cancel()
        ImageDownloader.shared.cancel()
    }
    
    func configure(withUrl url: String) {
        imageUrl = url
//        imageDownloader = ImageDownloader()
//        imageDownloader?.cell = self
        label.text = String(index! + 1)
//        label.isHidden = true
        ImageDownloader.shared.startLoad(withUrl: url, completion: { [weak self] (cachedImage, downloadedImage) in
            guard let self = self else { return }
            if let image = cachedImage {
                self.showCachedImage(image)
            } else if let image = downloadedImage {
                self.showImage(image)
            }
        })
    }
    
    func showCachedImage(_ cachedImage: UIImage) {
        guard cachedImage !== imageView.image else { return }
        imageView.image = cachedImage
    }
    
    func showImage(_ downloadedImage: UIImage) {
        imageView.image = downloadedImage
        guard let index = index else { return }
        delegate?.photoCell(self, downloadedImage: downloadedImage, index: index)
    }
}
