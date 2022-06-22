//
//  DetailViewController.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 09.06.2022.
//

import UIKit
import RealmSwift

final class DetailViewController: UIViewController{
    
    var unsplashImageObject: UnsplashImagesCollectionModel?
    
    let realm = try! Realm()
    
    private let autorNameLabel = UILabel()
    private let dateCreateLabel = UILabel()
    private let locationLabel = UILabel()
    private let numbersOfDownloadLabel = UILabel()
    
    private let generalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let favoriteCheckmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let attributeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        renderingSelectedImageView()
        renderingIndicator()
        renderingStackView()
        renderingScrollView()
        selectedImageTap()
        favoriteCheckmarkTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if realm.object(ofType: RealmImagesCollectionModel.self, forPrimaryKey: unsplashImageObject?.id) == nil {
            favoriteCheckmarkImage.image = UIImage(systemName: "heart")
            favoriteCheckmarkImage.tintColor = .black
        } else {
            favoriteCheckmarkImage.image = UIImage(systemName: "heart.fill")
            favoriteCheckmarkImage.tintColor = .systemRed
        }
        
    }
    
    
    //MARK: - Init object
    
    private func initRealmFromUnsplsh(unsplashObject: UnsplashImagesCollectionModel?) ->RealmImagesCollectionModel{
        
        let imageObject = RealmImagesCollectionModel()
        imageObject.id = unsplashObject?.id ?? "_"
        imageObject.city = unsplashObject?.location?.city ?? "_"
        imageObject.downloads = unsplashObject?.downloads ?? 0
        imageObject.userName = unsplashObject?.user?.name ?? "_"
        imageObject.created_at = unsplashObject?.created_at ?? "_"
        imageObject.imageSmall = unsplashObject?.imageSmall
        imageObject.imageFull = unsplashObject?.imageFull
        return imageObject
    }
    
    private func initUnsplashFromRealm(realmObgect: RealmImagesCollectionModel) ->UnsplashImagesCollectionModel{
        
        let selectedObject = UnsplashImagesCollectionModel(id: realmObgect.id,
                                                           created_at: realmObgect.created_at,
                                                           width: 0, height: 0,
                                                           downloads: realmObgect.downloads,
                                                           location: Location.init(city: realmObgect.city),
                                                           urls: nil,
                                                           user: nil,
                                                           imageFull: realmObgect.imageFull,
                                                           imageSmall: realmObgect.imageSmall)
        return selectedObject
    }
    
    
    //MARK: - Rendering UI elements
    
    private func renderingScrollView() {
        
        view.addSubview(generalScrollView)
        NSLayoutConstraint.activate([
            generalScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            generalScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            generalScrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            generalScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            generalScrollView.heightAnchor.constraint(equalTo: selectedImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func renderingStackView(){
        
        attributeStackView.addArrangedSubview(favoriteCheckmarkImage)
        attributeStackView.addArrangedSubview(autorNameLabel)
        attributeStackView.addArrangedSubview(locationLabel)
        attributeStackView.addArrangedSubview(numbersOfDownloadLabel)
        attributeStackView.addArrangedSubview(dateCreateLabel)
        generalScrollView.addSubview(attributeStackView)
        NSLayoutConstraint.activate([
            favoriteCheckmarkImage.widthAnchor.constraint(equalToConstant: 50),
            favoriteCheckmarkImage.heightAnchor.constraint(equalTo: favoriteCheckmarkImage.widthAnchor, multiplier: 0.8),
            attributeStackView.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor, constant: 10),
            attributeStackView.leftAnchor.constraint(equalTo: generalScrollView.leftAnchor, constant: 10),
            attributeStackView.rightAnchor.constraint(equalTo: generalScrollView.rightAnchor, constant: -10),
            attributeStackView.bottomAnchor.constraint(equalTo: generalScrollView.bottomAnchor, constant: -10),
            attributeStackView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func renderingIndicator(){
        
        loadingActivityIndicator.startAnimating()
        selectedImageView.addSubview(loadingActivityIndicator)
        NSLayoutConstraint.activate([
            loadingActivityIndicator.centerXAnchor.constraint(equalTo: selectedImageView.centerXAnchor, constant: 0),
            loadingActivityIndicator.centerYAnchor.constraint(equalTo: selectedImageView.centerYAnchor, constant: 0)
        ])
    }
    
    private func renderingSelectedImageView(){
        
        generalScrollView.addSubview(selectedImageView)
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: generalScrollView.topAnchor, constant: 0),
            selectedImageView.rightAnchor.constraint(equalTo: generalScrollView.rightAnchor, constant: 0),
            selectedImageView.leftAnchor.constraint(equalTo: generalScrollView.leftAnchor, constant: 0),
            selectedImageView.widthAnchor.constraint(equalTo: generalScrollView.widthAnchor, multiplier: 1)
        ])
    }
    
    
    //MARK: - Download images
    
    private func loadSelectedImage(imageURL: String){
        
        guard let imageURL = URL(string: imageURL) else {return}
        guard let imageData = try? Data(contentsOf: imageURL) else {return}
        DispatchQueue.main.async {
            self.selectedImageView.image = UIImage(data: imageData)
            self.unsplashImageObject?.imageFull = imageData
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    private func loadSelectedImageSmall(imageURL: String){
        
        guard let imageURL = URL(string: imageURL) else {return}
        guard let imageData = try? Data(contentsOf: imageURL) else {return}
        DispatchQueue.main.async {
            self.unsplashImageObject?.imageSmall = imageData
        }
    }
    
    
    //MARK: - Configure UI with Data
    
    func configureDataWithUnsplash(objectModel: UnsplashImagesCollectionModel) {
        
        unsplashImageObject = objectModel
        loadSelectedImage(imageURL:  unsplashImageObject?.urls?.full ?? "")
        loadSelectedImageSmall(imageURL:  unsplashImageObject?.urls?.small ?? "")
        autorNameLabel.text = "Author: \( unsplashImageObject?.user?.name ?? "_" )"
        dateCreateLabel.text = "Data: \(getDateFromString(date:  unsplashImageObject?.created_at ?? "_"))"
        locationLabel.text = "Location: \(unsplashImageObject?.location?.city ?? "_" )"
        numbersOfDownloadLabel.text = "Downloads: \(unsplashImageObject?.downloads ?? 0)"
    }
    
    func configureDataWithRealm(objectModel: RealmImagesCollectionModel) {
        
        unsplashImageObject = initUnsplashFromRealm(realmObgect: objectModel)
        favoriteCheckmarkImage.image = UIImage(systemName: "heart.fill")
        favoriteCheckmarkImage.tintColor = .systemRed
        selectedImageView.image = UIImage(data: objectModel.imageFull!)
        autorNameLabel.text = "Author: \(objectModel.userName)"
        dateCreateLabel.text = "Data: \(getDateFromString(date: objectModel.created_at))"
        locationLabel.text = "Location: \(objectModel.city)"
        numbersOfDownloadLabel.text = "Downloads: \(objectModel.downloads)"
        DispatchQueue.main.async {
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    
    private func getDateFromString(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let data = dateFormatter.date(from: date) ?? Date()
        return dateFormatter.string(from: data)
    }
    
}

extension DetailViewController {
    
    //MARK: - Realm function
    
    private func saveImage(){
        
        guard realm.object(ofType: RealmImagesCollectionModel.self, forPrimaryKey: unsplashImageObject?.id) == nil else {return}
        let imageObject = initRealmFromUnsplsh(unsplashObject: unsplashImageObject)
        try! realm.write {
            realm.add(imageObject)
        }
    }
    
    private func deleteImage(){
        
        guard let deleteObject = realm.object(ofType: RealmImagesCollectionModel.self, forPrimaryKey: unsplashImageObject?.id) else {return}
        try! realm.write {
            realm.delete(deleteObject)
        }
    }
    
    
    //MARK: - Setup gesture
    
    private func favoriteCheckmarkTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didOneTap))
        tapGesture.numberOfTapsRequired = 1
        favoriteCheckmarkImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didOneTap(){
        
        if favoriteCheckmarkImage.image == UIImage(systemName: "heart.fill") {
            favoriteCheckmarkImage.image = UIImage(systemName: "heart")
            favoriteCheckmarkImage.tintColor = .black
            deleteImage()
        } else {
            favoriteCheckmarkImage.image = UIImage(systemName: "heart.fill")
            favoriteCheckmarkImage.tintColor = .systemRed
            saveImage()
        }
    }
    
    private func selectedImageTap(){
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didDoubleTap(_:)))
        tapGesture.numberOfTapsRequired = 2
        selectedImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer){
        
        favoriteCheckmarkImage.image = UIImage(systemName: "heart.fill")
        favoriteCheckmarkImage.tintColor = .systemRed
        saveImage()
        
        guard let gestureView = gesture.view else {return}
        let size = gestureView.frame.size.width/4
        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.frame = CGRect(x: (gestureView.frame.size.width - size)/2,
                             y: (gestureView.frame.size.height - size)/2,
                             width: size,
                             height: size * 0.8)
        heart.tintColor = .white
        
        gestureView.addSubview(heart)
        UIView.animate(withDuration: 0.5, animations: {
            heart.alpha = 1
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 1, animations: {
                    heart.alpha = 0
                }, completion: { done in
                    if done {
                        heart.removeFromSuperview()
                    }
                })
            }
        })
    }
    
    
}
