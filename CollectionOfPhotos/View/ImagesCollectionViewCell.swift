//
//  ImagesCollectionViewCell.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 09.06.2022.
//

import UIKit

final class ImagesCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "cell"
    
    var imageCache = NSCache<NSString, NSData>()
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        renderingCellImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
    }
    
    //MARK: - Rendering cell
    
    private func renderingCellImageView() {
        
        addSubview(cellImageView)
        cellImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cellImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    
    //MARK: - Loading and geting data from cache
    
    func imageConfigure(with model: UnsplashImagesCollectionModel){
        
        guard let stringURL = model.urls?.regular else {return}
        guard let imageURL = URL(string: stringURL) else {return}
        
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            self.cellImageView.image = UIImage(data: cachedImage as Data)
        }
        else {
            DispatchQueue.main.async {
                guard let imageData = try? Data(contentsOf: imageURL) else {return}
                self.cellImageView.image = UIImage(data: imageData)
                
                self.imageCache.setObject(imageData as NSData, forKey: imageURL.absoluteString as NSString)
            }
        }
    }
    
    
}
