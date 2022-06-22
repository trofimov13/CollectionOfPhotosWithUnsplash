//
//  RealmModel.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 15.06.2022.
//

import Foundation
import RealmSwift

final class RealmImagesCollectionModel: Object {
    
    @Persisted var id: String = ""
    @Persisted var created_at: String = ""
    @Persisted var downloads: Int = 0
    @Persisted var city: String = ""
    @Persisted var userName: String = ""
    @Persisted var imageFull: Data?
    @Persisted var imageSmall: Data?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

