//
//  Student.swift
//  ConsumingSoapService
//
//  Created by Beniamin on 15.05.22.
//

import Foundation

struct Student {
    let id: Int
    let name: String
    
    init?(details: [String: Any]) {
        if let stringId = details["id"] as? String, let intId = Int(stringId) {
            id = intId
        } else {
           return nil
        }
        name = details["name"] as? String ?? ""
    }
}
