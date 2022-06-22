//
//  UnsplashImagesCollectionModel.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 09.06.2022.
//
//


import Foundation

// MARK: - UnsplashImagesCollectionModelElement

struct UnsplashImagesCollectionModel: Codable {
    
    var id: String
    var created_at: String
    var width: Int
    var height: Int
    var downloads: Int
    var location: Location?
    let urls: Urls?
    var user: User?
    var imageFull: Data?
    var imageSmall: Data?
    
}

// MARK: - Location

struct Location: Codable {
    
    var name: String?
    var city: String?
    var country: String?
    
}

// MARK: - Urls

struct Urls: Codable {
    
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    
}

// MARK: - User

struct User: Codable {
    
    var id: String?
    var updated_at: String?
    var username: String?
    var name: String?
}
