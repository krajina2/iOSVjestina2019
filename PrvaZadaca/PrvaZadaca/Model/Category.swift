//
//  Category.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 04/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import Foundation
import UIKit

enum Category: String, Decodable, CaseIterable {
    
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
            return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case .SCIENCE:
            return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        }
    }
    
    static func getCategory(for number: Int) -> Category? {
        switch number {
        case 0:
            return .SPORTS
        case 1:
            return .SCIENCE
        default:
            return nil
        }
    }
}
