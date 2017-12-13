//
//  NeewsService.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 25.11.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class NewsService {
    
    //базовый url сервиса
    let baseUrl = "https://api.vk.com"
    
    //метод для загрузки данных, в качестве аргументов получаем новости
    func loadNewsData(completion: @escaping ([News]) -> () ) {
        
        //путь для получния ленты новостей
        let path = "/method/newsfeed.get"
        let VKvers = "5.68"
        
        //параметры, ключ для доступа к сервису
        let parameters: Parameters = [
            "filters": "post,photo,wall_photo",
            "count": "15",
            "access_token" : "\(access_Token)",
            "v": VKvers
        ]
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //делаем запрос на ленту новостей
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInteractive))
            {repsons in
            guard let data = repsons.value else { return }
            
            let json = try? JSON(data:data)
            
           let newsFeed = json!["response"]["items"].flatMap{News(json: $0.1) }
               DispatchQueue.main.async {
                completion(newsFeed)
            }
        }
    }
}
