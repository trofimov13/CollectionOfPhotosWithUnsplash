//
//  FavoritesTableViewController.swift
//  CollectionOfPhotos
//
//  Created by Алексей Трофимов on 14.06.2022.
//

import UIKit
import RealmSwift

final class FavoritesTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var realmImagesCollection: Results<RealmImagesCollectionModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmImagesCollection = realm.objects(RealmImagesCollectionModel.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmImagesCollection.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier, for: indexPath) as! FavoritesTableViewCell
            cell.cellConfigure(with: realmImagesCollection[indexPath.item])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
  
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            showAlertOfDeleteObject(with: realmImagesCollection[indexPath.item], indexPath: indexPath)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController()
        detailVC.configureDataWithRealm(objectModel: realmImagesCollection[indexPath.item])
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}


extension FavoritesTableViewController {
    
    private func showAlertOfDeleteObject(with object: RealmImagesCollectionModel, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
        
        let doneAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            try! self?.realm.write {
                self?.realm.delete(object)
            }
            self?.tableView.deleteRows(at: [indexPath], with: .bottom)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        present(alert, animated: true)
    }
    
}
