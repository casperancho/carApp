//
//  RealUserModule.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 20.05.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmUser: Object {
    @objc dynamic var user_id: Int = 0
    @objc dynamic var user_name: String = ""
    @objc dynamic var user_surname: String = ""
    @objc dynamic var phone_number: String = ""
    var orders = List<String>()
    @objc dynamic var selectedCarId: Int = 0
    @objc dynamic var userClickedGoOrder: Bool = false
}
