//
//  NetworkManager.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 09.06.2022.
//

import Foundation

let accessKey = "3oKOq6mRdBnwyedL76xoVnJIdvLDMRFCE9gh1fX67lA"


final class NetworkManager {
    
    func fetchRequest(searchText: String, completion: @escaping (Data?, Error?)->Void) {
        
        let searchItems = self.prepareSearchItems(searchItem: searchText)
        let url = self.fetchUrl(component: searchItems)
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(accessKey)"
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        let task = dataTask(request: request, completion: completion)
        task.resume()
    }
    
    private func prepareSearchItems(searchItem: String?)->[String: String] {
        
        var searchItems = [String: String]()
        searchItems["query"] = searchItem
        searchItems["count"] = String(20)
        return searchItems
    }
    
    private func fetchUrl(component: [String: String])->URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random"
        components.queryItems = component.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func dataTask(request: URLRequest, completion: @escaping (Data?, Error?)->Void)->URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: request) { data, request, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    
}
