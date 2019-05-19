//
//  Response.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 19/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import Foundation

enum Response: Int {
    
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    
    var text: String {
        switch self {
        case .ok:
            return "Success"
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Authorization failed"
        case .forbidden:
            return "Token is not valid for sent user id"
        case .notFound:
            return "Resource not found"
        }
    }
}
