//
//  QuizService.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 04/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import Foundation

class QuizService {
    
    func fetchQuizes(completion: @escaping ([Quiz]?, Error?) -> ()) {
        let urlString = "https://iosquiz.herokuapp.com/api/quizzes"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error occured: ", error)
                    completion(nil, error)
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let game = try decoder.decode(Game.self, from: data)
                        completion(game.quizzes, nil)
                    } catch let jsonError {
                        print("Failed to decode json: ", jsonError)
                        completion(nil, jsonError)
                    }
                }
            }.resume()
        }
    }
    
}
