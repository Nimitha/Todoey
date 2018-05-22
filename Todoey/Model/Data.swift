//
//  Data.swift
//  Todoey
//
//  Created by DP on 21/05/18.
//  Copyright © 2018 nimitha. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age:Int = 0
}
