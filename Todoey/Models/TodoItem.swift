//
//  File.swift
//  Todoey
//
//  Created by Abdelrahman Youssef on 27/01/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

class TodoItem : Codable {
    
    var title: String
    var isCompleted: Bool
    
    init (isCompleted: Bool = false, title: String) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
