//
//  FavoriteTableViewCell.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 14.06.2022.
//

import UIKit

final class FavoritesTableViewCell: UITableViewCell {

    static let identifier = "cell"
    
    private let cellImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "heart")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        return image
    }()
    
    private let cellNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        renderingCellImageView()
        renderingCellNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //MARK: - Rendering UI elements
    
    private func renderingCellImageView() {
        
       self.addSubview(cellImageView)
        
        NSLayoutConstraint.activate([
            cellImageView.heightAnchor.constraint(equalToConstant: 90),
            cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cellImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            cellImageView.widthAnchor.constraint(equalToConstant: 90)
        ])
        
    }
    
    private func renderingCellNameLabel() {
        
        self.addSubview(cellNameLabel)
        
        NSLayoutConstraint.activate([
            cellNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cellNameLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 20),
            cellNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
        ])
        
    }
    
    
    //MARK: - Setup cell configure
    
    func cellConfigure(with model: RealmImagesCollectionModel){
        cellNameLabel.text = model.userName
        
        guard let imageData = model.imageSmall else {return}
        
        DispatchQueue.main.async {
            self.cellImageView.image = UIImage(data: imageData)
            }
        
        }
    
    
}
