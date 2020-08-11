//
//  Item.swift
//  Todoey
//
//  Created by Victoria Boichenko on 10.08.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var done : Bool = false
    @objc dynamic var title : String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
