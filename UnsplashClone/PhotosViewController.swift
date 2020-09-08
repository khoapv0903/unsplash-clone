//
//  PhotosViewController.swift
//  UnsplashClone
//
//  Created by Khoa Pham on 9/7/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? UnsplashLayout {
          layout.delegate = self
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        
        PhotosService().listPhotos { (photos, error) in
            if let error = error {
                print(error.errorDescription ?? "")
            } else if let photos = photos {
                var i = 0
                photos.forEach { (photo) in
                    i += 1
                    print("\(i). \(photo.urls.thumb)\n")
                    self.photos.append(photo.urls.thumb)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
//        self.photos = ["https://images.unsplash.com/photo-1593642634367-d91a135587b5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjE2Mzg0NH0"]
    }

}

extension PhotosViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.index = indexPath.item
        cell.configure(withUrl: photos[indexPath.item])
        cell.delegate = self
        return cell
    }
}

extension PhotosViewController: UnsplashLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageUrl = photos[indexPath.item]
        let url = URL(string: imageUrl)!
        if let image = ImageCache.shared[url] {
            return image.size.height
        }
        return 100
    }
}

extension PhotosViewController: PhotoCellDelegate {
    func photoCell(_ cell: PhotoCell, downloadedImage: UIImage, index: Int) {
        // Perform any cell reloads without animation because there is no movement.
        UIView.performWithoutAnimation {
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            })
        }
    }
}
