//
//  FriendsPhotoViewController.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 15.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class FriendsPhotoViewController: UICollectionViewController {

    var friendId = 0
    let friendsService = FriendsService()
    var friendsPhoto = [FriendsPhoto]()
    var photos: [Int: UIImage] = [:]
    
    //свойство с очередью для запуска операций.
    let queue: OperationQueue = {
        let queue = OperationQueue ()
        queue.qualityOfService = .userInteractive
        return queue
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //отправим запрос для получения фото
        friendsService.loadFriendsPhotoData(forFriends: friendId) {[weak self] friendsPhoto in
            
        //сохраняем полученные данные в массиве, что бы коллекция могла получить к ним доступ
        //self?.friendsPhoto = friendsPhoto
        
        self?.loadData()
            
        //коллекция должна прочитать новые данные
        self?.collectionView?.reloadData()
        }
    }
    
    //получаем данные из Realm
    func loadData() {
        do {
            let realm = try Realm()
            
            let friendsPhoto = realm.objects(FriendsPhoto.self)
            
            self.friendsPhoto = Array(friendsPhoto)
            
        } catch {
            //если произошла ошибка выводим ее в консоль
            print("ERRRRRRROR PHOTO!!!!!", error)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsPhoto.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! FriendsPhotoViewCell
        
        let photo = friendsPhoto[indexPath.row]
        
        if let photo = photos[indexPath.row] {
            cell.friendsPhoto.image = photo
        } else {
            loadPhotos(indexPath: indexPath)
        }
        
        //кеширование фото
        let getCacheImage = GetCacheImage(url: photo.url)
        let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, collectionView:
            collectionView)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
        
        return cell
    }
    
    func loadPhotos(indexPath: IndexPath) {
        func downloadPhoto(byUrl url: String, completion: @escaping (UIImage) -> Void) {
            Alamofire.request(url).responseData { response in
                
                guard
                    let data = response.data,
                    let image = UIImage(data: data) else { return }
                
                completion(image)
            }
        }
        downloadPhoto(byUrl: friendsPhoto[indexPath.row].photo) { [weak self] image in
            self?.photos[indexPath.row] = image
            self?.collectionView?.reloadItems(at: [indexPath])
        }
    }
    
    class SetImageToRow: Operation {
        private let indexPath: IndexPath
        private weak var collectionView: UICollectionView?
        private var cell: FriendsPhotoViewCell?
        init (cell: FriendsPhotoViewCell, indexPath: IndexPath, collectionView: UICollectionView)
        {
            self.indexPath = indexPath
            self.collectionView = collectionView
            self.cell = cell
        }
        
        override func main() {
            guard let collectionView = collectionView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else{return}
            if let newIndexPath = collectionView.indexPath(for: cell), newIndexPath == indexPath
            {
                cell.friendsPhoto.image = image
            } else if collectionView.indexPath(for: cell) == nil {
                cell.friendsPhoto.image = image
            }
        }
    }
}
