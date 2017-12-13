//
//  NeewsService.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 25.11.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsService {
    
    //базовый url сервиса
    let baseUrl = "http://api.vk.com"
    
    //метод для загрузки данных, в качестве аргументов получаем друзей
    func loadFriendsData() {
        
        //путь для получния друзей
        let path = "/method/newsfeed.get"
        let userID = "385198"
        let VKvers = "5.68"
        
        //параметры, ключ для доступа к сервису
        let parameters: Parameters = [
            "user_id": userID,
            "v": VKvers,
            "access_token" : "\(access_Token)",
            "source_id": "post,photo,photo_tag,wall_photo"
        ]
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //делаем запрос на друзей
        Alamofire.request(url, method: .get, parameters: parameters).responseData{[weak self] repsons in
            guard let data = repsons.value else { return }
            
            let json = try? JSON(data:data)
            
            let newsFeed = json!["response"]["items"].flatMap {Friends(json: $0.1) }
            completion(newsFeed)
        }
    }
}
