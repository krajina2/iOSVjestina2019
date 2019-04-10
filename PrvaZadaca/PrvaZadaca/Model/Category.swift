//
//  Category.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 04/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import Foundation
import UIKit

enum Category: String, Decodable {
    
    case SPORTS
    case SCIENCE
    
    var text: String {
        switch self {
        case .SPORTS:
            return "SPORTS"
        case .SCIENCE:
            return "SCIENCE"
        }
    }
    
    var color: UIColor {
        switch self {
        case .SPORTS:
            return UIColor.gray
        case .SCIENCE:
            return UIColor.green
        }
    }
    
}
