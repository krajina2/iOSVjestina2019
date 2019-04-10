//
//  ImageService.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 08/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    func fetchImage(imageUrl: String, completion: @escaping ((UIImage?) -> Void)) {
        if let url = URL(string: imageUrl) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
    
}
