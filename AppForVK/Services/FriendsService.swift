//
//  FriendsService.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 20.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class FriendsService {
    
    //let url: String = "http://api.vk.com/method/friends.get?user_id=385198&v=5.68"
    //базовый url сервиса
    let baseUrl = "http://api.vk.com"
    
    //сохранение данных друзей в realm
    func saveFriendsData(_ friends: [Friends]) {
        //обработка исключений при работе с хранилищем
        do {
            //получаем доступ к хранилищу
            let realm = try Realm()
            
            //все старые данные
            let oldFriends = realm.objects(Friends.self)
            
            //начинаем изменять хранилище
            realm.beginWrite()
            
            //удаляем старые данные
            realm.delete(oldFriends)
            
            //кладем все объекты класса друзей в хранилище
            realm.add(friends)
            
            //завершаем изменять хранилище
            try realm.commitWrite()
        } catch {
            //если произошла ошибка выводим ее в консоль
            print("ERROR FRIENDS", error)
        }
    }
    
    //сохранение данных фото друзей в realm
    func saveFriendsPhotoData(_ friendsPhoto: [FriendsPhoto]) {
        //обработка исключений при работе с хранилищем
        do {
            //получаем доступ к хранилищу
            let realm = try Realm()
            
            //все старые данные
            let oldFriendsPhoto = realm.objects(FriendsPhoto.self)
            
            //начинаем изменять хранилище
            realm.beginWrite()
            
            //удаляем старые данные
            realm.delete(oldFriendsPhoto)
            
            //кладем все объекты класса фото друзей в хранилище
            realm.add(friendsPhoto)
            
            //завершаем изменять хранилище
            try realm.commitWrite()
        } catch {
            //если произошла ошибка выводим ее в консоль
            print("ERROR PHOTO", error)
        }
    }
    
    //метод для загрузки данных, в качестве аргументов получаем друзей
    func loadFriendsData() {
        
        //путь для получния друзей
        let path = "/method/friends.get"
        let userID = "*******"
        let VKvers = "5.68"
        
        //параметры, ключ для доступа к сервису
        let parameters: Parameters = [
            "user_id": userID,
            "v": VKvers,
            "fields": "first_name,photo_50"
        ]
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
            
        //делаем запрос на друзей
        Alamofire.request(url, method: .get, parameters: parameters).responseData{[weak self] repsons in
            guard let data = repsons.value else { return }
            
            let json = try? JSON(data:data)

            let friends = json!["response"]["items"].flatMap {Friends(json: $0.1) }
            self?.saveFriendsData(friends)
        }
    }
    
    func loadFriendsPhotoData(forFriends friend: Int, completion: @escaping ([FriendsPhoto]) -> Void) {
        
        let urlPhoto = "https://api.vk.com"
        
        //путь для получния друзей
        let path = "/method/photos.getAll"
        let VKvers = "5.68"
        
        //параметры, ключ для доступа к сервису
        let parameters: Parameters = [
            "count": "50",
            "owner_id": friend,
            "v": VKvers,
            "access_token": "\(access_Token)",
            "fields": "first_name,photo_50"
        ]
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = urlPhoto+path
        
        //делаем запрос на друзей
        Alamofire.request(url, method: .get, parameters: parameters).responseData{[weak self] repsons in
            guard let data = repsons.value else { return }
            
            let json = try? JSON(data:data)
            
            let friendsPhoto = json!["response"]["items"].flatMap {FriendsPhoto(json: $0.1) }
            self?.saveFriendsPhotoData(friendsPhoto)
            completion(friendsPhoto)
        }
    }
    
    //получаем данные из Realm
    func loadData() -> [Friends]{
        do {
            let realm = try Realm()
            return Array(realm.objects(Friends.self))
        } catch {
            //если произошла ошибка выводим ее в консоль
            print("ERRRRRRROR!!!!!", error)
            return[]
        }
    }
}


