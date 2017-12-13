//
//  NewsFeedController.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 25.11.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import Alamofire

class NewsFeedController: UITableViewController {

    let newsService = NewsService()
    var news = [News]()
    var newsPhoto: [Int: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsService.loadNewsData() {[weak self] newsFeed in
            //сохраняем полученные данные в массиве, что бы коллекция могла получить к ним доступ
            self?.news = newsFeed
            //коллекция должна прочитать новые данные
            self?.tableView?.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsFeedCell

        //устанавливаем новости в надпись ячейки
        let newsPost = news[indexPath.row]
        
        //текст новости
        cell.newsText.text = newsPost.text
        
        //фото для новостей
        if let photo = newsPhoto[indexPath.row] {
            cell.photo.image = photo
        } else {
            loadPhotos(indexPath: indexPath)
        }
        return cell
    }
    
    func loadPhotos(indexPath: IndexPath) {
        func downloadPhoto(byUrl url: String, completion: @escaping (UIImage) -> Void) {
            Alamofire.request(url).responseData(queue: .global(qos: .userInteractive)){
                response in
                guard
                    let data = response.data,
                    let image = UIImage(data: data) else { return }
               
                completion(image)
            }
        }
            downloadPhoto(byUrl: self.news[indexPath.row].photoNews) {[weak self] image in
                self?.newsPhoto[indexPath.row] = image
            DispatchQueue.main.async {
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}
