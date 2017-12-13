//
//  AllGroupsController.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 16.10.17.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AllGroupsController: UITableViewController, UISearchBarDelegate {

    var allGroups: [Groups] = []
    let groupsService = GroupsService()
    var groupsPhoto: [Int: UIImage] = [:]
    var selectedRows: [Int] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        searchBarSearchButtonClicked(searchBar)
    }

    //поиск групп
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard
                let text = searchBar.text,
                !text.isEmpty else {
                    tableView.reloadData()
                    return
            }
            searchGroups(request: text)
            getMemebers(groupId: text)
            tableView.reloadData()
        }
    
        func searchGroups(request: String) {
            groupsService.loadGroupsSearchData(request: request) { [weak self] groups in
                self?.allGroups = groups
                self?.tableView.reloadData()
            }
        }
    
        func getMemebers(groupId: String) {
            groupsService.loadGroupsMembers(groupsId: groupId) { [weak self] groups in
                self?.allGroups = groups
                self?.tableView.reloadData()
            }
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allGroups.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell
            
            let group = allGroups[indexPath.row]
            
            cell.allGroupsName.text = group.name
            cell.allGroupsNumberOfSub.text = String(group.members)
            
            if let photo = groupsPhoto[indexPath.row] {
                cell.allGroupsAva.image = photo
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
            downloadPhoto(byUrl: allGroups[indexPath.row].photo) { [weak self] image in
                self?.groupsPhoto[indexPath.row] = image
                self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
