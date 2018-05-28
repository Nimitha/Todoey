//
//  Category.swift
//  Todoey
//
//  Created by DP on 22/05/18.
//  Copyright © 2018 nimitha. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var colour:String?
    let items = List<Item>()
}
