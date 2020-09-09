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
    var page: Int = 0
    var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView.collectionViewLayout as? UnsplashLayout {
          layout.delegate = self
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        
        fetchPhotos()
        
//        if let path = Bundle.main.path(forResource: "Photos", ofType: "plist") {
//            if let urls = NSArray(contentsOfFile: path) {
//                for url in urls {
//                    self.photos.append(url as! String)
//                }
//            }
//        }
    }
    
    func fetchPhotos() {
        guard !isLoading else { return }
        page += 1
        isLoading = true
        PhotosService().listPhotos(page: page) { (photos, error) in
            self.isLoading = false
            if let error = error {
                print(error.errorDescription ?? "")
            } else if let photos = photos {
//                var i = 0
                photos.forEach { (photo) in
//                    i += 1
//                    print("\(i). \(photo.urls.thumb)\n")
                    self.photos.append(photo.urls.thumb)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
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

extension PhotosViewController: UICollectionViewDelegate {
    
    // Load more photos
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = collectionView.contentSize.height - view.frame.height
        if (scrollView.contentOffset.y - offset) >= 0 && page < 5 {
            fetchPhotos()
        }
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



