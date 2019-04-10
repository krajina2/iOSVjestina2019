//
//  Quiz.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 04/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import Foundation

class Quiz: Decodable {
    
    let id: Int?
    let title: String?
    let description: String?
    let category: Category?
    let level: Int?
    let image: String?
    let questions: [Question]?
    
}
