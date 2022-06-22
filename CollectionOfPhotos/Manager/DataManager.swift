//
//  DataManager.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 09.06.2022.
//

import Foundation

final class DataManager {
    
    var networkService = NetworkManager()
    
    func fetchImages(searchText: String, completion: @escaping ([UnsplashImagesCollectionModel]?) -> ()) {
        
        networkService.fetchRequest(searchText: searchText) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
            }
            
            do {
                guard let data = data else {return}
                let decode = try JSONDecoder().decode([UnsplashImagesCollectionModel].self, from: data)
                completion(decode)
            }
            catch {
                print("The limit is exceeded")
            }
            
        }
        
    }
    
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
    
}
