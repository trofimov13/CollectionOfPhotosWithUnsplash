//
//  ImagesCollectionViewController.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 09.06.2022.
//

import UIKit

final class ImagesCollectionViewController: UICollectionViewController {
    
    private var dataManager = DataManager()
    
    private var unsplashImagesCollection = [UnsplashImagesCollectionModel]()
    
    private let loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        fetchRandomImages()
        renderingActivityIndicator()
    }
    
    
    // MARK: - Setup UI elements
    
    private func setupCollectionView(){
        
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: ImagesCollectionViewCell.identifire)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        if let waterfallLayout = collectionViewLayout as? WaterfallLayout {
            waterfallLayout.delegate = self
        }
    }
    
    private func setupSearchBar(){
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
    }
    
    private func renderingActivityIndicator() {
        
        view.addSubview(loadingActivityIndicator)
        loadingActivityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        loadingActivityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
    
    private func fetchRandomImages() {
        
        loadingActivityIndicator.startAnimating()
        dataManager.fetchImages(searchText: "") { [weak self] searchResults in
            guard let searchResults = searchResults else { return }
            self?.unsplashImagesCollection = searchResults
            self?.collectionView.reloadData()
            self?.loadingActivityIndicator.stopAnimating()
        }
    }
    
    
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController()
        detailVC.configureDataWithUnsplash(objectModel: unsplashImagesCollection[indexPath.item])
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashImagesCollection.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.identifire, for: indexPath) as! ImagesCollectionViewCell
        cell.imageConfigure(with: unsplashImagesCollection[indexPath.item])
        return cell
    }
        

}

extension ImagesCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.loadingActivityIndicator.startAnimating()
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text else {return}
        dataManager.fetchImages(searchText: searchText) { [weak self] searchResults in
            guard let searchResults = searchResults else { return }
            self?.unsplashImagesCollection = searchResults
            self?.collectionView.reloadData()
            self?.loadingActivityIndicator.stopAnimating()
        }
        
    }
    
    
}

extension ImagesCollectionViewController: WaterfallLayoutDelegate {
    
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = unsplashImagesCollection[indexPath.item]
        return CGSize(width: photo.width, height: photo.height)
    }
    
}
