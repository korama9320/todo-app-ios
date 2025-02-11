//
//  TodoItem.swift
//  Todoey
//
//  Created by Roboost Mobile on 10/02/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date = Date()
    var parentCategory = LinkingObjects(fromType: CategoryItem.self, property: "items")
    
}
