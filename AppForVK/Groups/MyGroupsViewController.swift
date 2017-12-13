//
//  MyGroupsViewController.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 15.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class MyGroupsViewController: UITableViewController {

    let groupsService = GroupsService()
    
    var groups = [Groups]()
    var groupsPhoto: [Int: UIImage] = [:]

    @IBAction func searchGroups(segue: UIStoryboardSegue) {
        //Проверяем идентификатор перехода, что бы убедится что это нужныий переход
        if segue.identifier == "addGroup" {
            //получаем ссылку на контроллер с которого осуществлен переход
            let allGroupsController = segue.source as! AllGroupsController
            guard allGroupsController.selectedRows.count != 0 else{
                return
            }
            for index in allGroupsController.selectedRows{
                var contains = false
        
            for group in groups {
                if group.name == allGroupsController.allGroups[index].name {
                    print("error")
                    contains = true
                    break
                }
            }
            if contains == false{
                groups.append(allGroupsController.allGroups.remove(at: index))
            }
        }
        tableView.reloadData()
        allGroupsController.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //если была нажата кнопка удалить
        if editingStyle == .delete {
            //мы удаляем группу из массива
            groups.remove(at: indexPath.row)
            //и удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //отправим запрос для получения групп
        groupsService.loadGroupsData() { [weak self] groups in
            
            //сохраняем полученные данные в массиве, что бы коллекция могла получить к ним доступ
            //self?.groups = groups
            self?.loadData()
            
            //коллекция должна прочитать новые данные
            self?.tableView?.reloadData()
        }
    }
    
    //получаем данные из Realm
    func loadData() {
        do {
            let realm = try Realm()
            
            let groups = realm.objects(Groups.self)
            
            self.groups = Array(groups)
            
        } catch {
            //если произошла ошибка выводим ее в консоль
            print("ERRRRRRROR Groups!!!!!", error)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as! MyGroupsViewCell
        
        //устанавливаем группы в надпись ячейки
        cell.configure(whithGroups: groups[indexPath.row])
    
        //устанавливаем аватарки
        if let photo = groupsPhoto[indexPath.row] {
            cell.groupsAva.image = photo
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
        downloadPhoto(byUrl: groups[indexPath.row].photo) { [weak self] image in
            self?.groupsPhoto[indexPath.row] = image
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
