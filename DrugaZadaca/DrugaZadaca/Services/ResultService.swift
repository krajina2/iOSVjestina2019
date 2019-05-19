//
//  ResultService.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 19/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import Foundation

class ResultService {
    
    func sendResult(completion: @escaping (Response?, Error?) -> (), quiz: Quiz, correctAnswers: Int, time: Double) {
        let urlString = "https://iosquiz.herokuapp.com/api/result"
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaults.standard.string(forKey: "accesToken") {
                request.addValue(token, forHTTPHeaderField: "Authorization")
            } else {
                return
            }
            
            let parameters: [String: Any] = [
                "quiz_id": quiz.id!,
                "user_id": 2,
                "time": time,
                "no_of_correct": correctAnswers
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject:
                    parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error occured: ", error)
                    completion(nil, error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    completion(Response(rawValue: httpResponse.statusCode), nil)
                }
            }.resume()
        }
    }
    
    func getResults(quizId: Int, completion: @escaping ([Result]?, Error?) -> ()) {
        let urlString = "https://iosquiz.herokuapp.com/api/score?quiz_id=\(quizId)"
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = UserDefaults.standard.string(forKey: "accesToken") {
                request.addValue(token, forHTTPHeaderField: "Authorization")
            } else {
                return
            }
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error occured: ", error)
                    completion(nil, error)
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let results = try decoder.decode([Result].self, from: data)
                        completion(results, nil)
                    } catch let jsonError {
                        print("Failed to decode json: ", jsonError)
                        completion(nil, jsonError)
                    }
                }
            }.resume()
        }
    }
    
}
