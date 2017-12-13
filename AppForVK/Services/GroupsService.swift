//
//  GroupsService.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 22.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class GroupsService {
    
    //let url: String = "https://api.vk.com/method/groups.get?user_id=385198&v=5.68"

    //базовый url сервиса
    let baseUrl = "https://api.vk.com"
    
    //сохранение данных групп в realm
    func saveGroupsData(_ groups: [Groups]) {
        //обработка исключений при работе с хранилищем
        do {
            //получаем доступ к хранилищу
            let realm = try Realm()
            
            //начинаем изменять хранилище
            //все старые данные
            let oldGroups = realm.objects(Groups.self)
            
            realm.beginWrite()
            
            //удаляем старые данные
            realm.delete(oldGroups)
            
            //кладем все объекты класса группы в хранилище
            realm.add(groups)
            
            //завершаем изменять хранилище
            try realm.commitWrite()
        } catch {
            //если произошла ошибка выводим ее в консоль
            print("ERROR GROUPS", error)
        }
    }
    
    //метод для загрузки данных, в качестве аргументов получает группы
    func loadGroupsData(completion: @escaping ([Groups]) -> Void){
        
        //путь для получния групп
        let path = "/method/groups.get"
        
        //параметры, ключ для доступа к сервису
        let parameters: Parameters = [
            "count" : "100",
            "v" : "5.68",
            "access_token" : "\(access_Token)",
            "extended" : "1",
            "fields": "name,photo_50"
        ]
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path

        //делаем запрос на группы
        Alamofire.request(url, method: .get, parameters: parameters).responseData{[weak self] repsons in
            guard let data = repsons.value else { return }
            
            let json = try? JSON(data:data)
            
            let groups = json!["response"]["items"].flatMap {Groups(json: $0.1) }
            self?.saveGroupsData(groups)
            completion(groups)
        }
    }
    
    func loadGroupsSearchData(request: String, completion: @escaping ([Groups]) -> () ){
        
        //путь для получния групп
        let path = "/method/groups.search"
        
        //параметры, ключ для доступа к сервису
        let parameters: Parameters = [
            "q": request,
            "v" : "5.68",
            "access_token" : "\(access_Token)",
            "count": "20",
            "type": "group"
        ]
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //делаем запрос на группы
        Alamofire.request(url, method: .get, parameters: parameters).responseData{repsons in
            guard let data = repsons.value else { return }
            
            let json = try? JSON(data:data)
            
            let searchGroups = json!["response"]["items"].array?.flatMap { String(describing: $0["id"].intValue) }.joined(separator: ",") ?? ""
            self.loadGroupsMembers(groupsId: searchGroups, completion: completion)
        }
    }
    
    func loadGroupsMembers(groupsId: String, completion: @escaping ([Groups]) -> () ){
        
        //путь для получния количество подписчиков на группу
        let path = "/method/groups.getById"
        
        //параметры, ключ для доступа к сервису
        let parameters: Parameters = [
            "group_ids": groupsId,
            "fields": "members_count",
            "v": "5.68",
            "access_token" : "\(access_Token)",
        ]
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters).responseData{repsons in
            guard let data = repsons.value else { return }
            
            let json = try? JSON(data:data)
            
            let groupsMembers = json!["response"].flatMap {Groups(json: $0.1) }
            completion(groupsMembers)
        }
    }
}
