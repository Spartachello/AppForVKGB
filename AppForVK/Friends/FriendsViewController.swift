//
//  FriendsViewController.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 15.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class FriendsViewController: UITableViewController {

    let friendsService = FriendsService()
    var friends = [FriendsPhoto]()
    var friendsPhoto: [Int: UIImage] = [:]
    
    var friendsRealm: Results<Friends>!
    var tokenRealm: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //отправим запрос для получения друзей
        friendsService.loadFriendsData()
        pairTableAndRealm()
    }
    
    //метод для того что бы получить из базы друзей и подписаться на уведомления об ее изменении.
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friendsRealm = realm.objects(Friends.self)
        tokenRealm = friendsRealm.observe {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .none)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsRealm.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsViewCell
        
        //устанавливаем друзей в надпись ячейки
        cell.configure(whithFriends: friendsRealm[indexPath.row])
        
        //устанавливаем аватарки
        if let photo = friendsPhoto[indexPath.row] {
            cell.friendsAva.image = photo
        } else {
            loadPhotos(indexPath: indexPath)
        }
        
        return cell
    }
    
    //Выгружаем аватарки
    func loadPhotos(indexPath: IndexPath) {
        func downloadPhoto(byUrl url: String, completion: @escaping (UIImage) -> Void) {
            Alamofire.request(url).responseData { response in
                
                guard
                    let data = response.data,
                    let image = UIImage(data: data) else { return }
                
                completion(image)
            }
        }
        downloadPhoto(byUrl: friendsRealm[indexPath.row].photo) { [weak self] image in
        self?.friendsPhoto[indexPath.row] = image
        self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    //для перехода на контроллер с фотками
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendsPhoto", let ctrl = segue.destination as? FriendsPhotoViewController, let indexpath = tableView.indexPathForSelectedRow {
            ctrl.friendId = friendsRealm[indexpath.row].id
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     
     let friend = friendsRealm[indexPath.row]
     if editingStyle == .delete {
     do {
     let realm = try Realm()
     realm.beginWrite()
     realm.delete(friend)
     try realm.commitWrite()
     } catch {
     print(error)
            }
        }
    }
}
