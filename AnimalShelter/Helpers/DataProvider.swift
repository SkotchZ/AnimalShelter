//
//  DataProvider.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/10/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation
import UIKit

class DataProvider{
    
    var imageCache = NSCache<NSString, UIImage>()
    
    func dowloadImage(url: URL, complition: @escaping(UIImage?)->Void){
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString){
            complition(cachedImage)
        }
        else{
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard error == nil, data != nil,
                let res = response as? HTTPURLResponse,
                res.statusCode == 200,
                    let `self` =  self else{
                        return
                }
                
                guard let image = UIImage(data: data!) else {return}
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    complition(image)
                }
            }
            dataTask.resume()
        }
        
    }
}
