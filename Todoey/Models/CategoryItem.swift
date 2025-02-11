//
//  CategoryItem.swift
//  Todoey
//
//  Created by Roboost Mobile on 10/02/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import Foundation
import RealmSwift

class CategoryItem: Object {
    @objc dynamic var title: String = ""
    var items  = List<TodoItem>()
    
   
}
