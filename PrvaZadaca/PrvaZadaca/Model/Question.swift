//
//  Question.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 04/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import Foundation

class Question: Decodable {
    
    let id: Int?
    let question: String?
    let answers: [String]?
    let correctAnswer: Int?
    
}
