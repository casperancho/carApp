//
//  RealmCarModule.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 09.05.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmCar: Object {
    @objc dynamic var car_id: Int = 0
    @objc dynamic var car_name: String = ""
    @objc dynamic var car_year: Int = 0
    @objc dynamic var car_number: String = ""
    @objc dynamic var car_karaoke: Int = 0
    @objc dynamic var car_owner: Int = 0
    @objc dynamic var car_color: String = ""
    @objc dynamic var car_group: Int = 0
    @objc dynamic var car_is_activ: Int = 0
    @objc dynamic var car_is_change: Int = 0
}
