//
//  GetCacheImage.swift
//  AppForVK
//
//  Created by Спартак Ермолаев on 13.12.2017.
//  Copyright © 2017 Ermolaev Spartak. All rights reserved.
//

import Foundation
import UIKit

class GetCacheImage: Operation {
    private let cacheLifeTime: TimeInterval = 60//2592000
    private static let  pathName: String = {
        let pathName = "images"
        guard let  cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return pathName}
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    return pathName}()
    
    private lazy  var filePath:  String? = {guard let cachesDirectory  =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return  nil}
    let hasheName = String(describing: url.hashValue)
        return cachesDirectory.appendingPathComponent(GetCacheImage.pathName + " /" + hasheName).path
        
    }()
    
    private let url: String
    var outputImage: UIImage?
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        guard filePath != nil && !isCancelled else {return}
        if getImageFormChache() {return}
        guard !isCancelled else {return}
        if !downloadImage() {return}
        guard !isCancelled else {return}
        saveImageToChache()
    }
    
    private func getImageFormChache() -> Bool {
    guard let fileName = filePath,
        let info = try? FileManager.default.attributesOfItem(atPath: fileName),
        let modificationDate = info[FileAttributeKey.modificationDate] as? Date else {return false}
        
    let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else {return false}
        
        self.outputImage = image
        return true
    }
    
    private func downloadImage() -> Bool{
        guard let url = URL(string: url),
        let data = try? Data(contentsOf: url),
        let image = UIImage(data: data) else {return false}
        
        self.outputImage = image
        return true
    }
    
    private func saveImageToChache() {
        guard let fileName = filePath,
        let image = outputImage else {return}
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}
