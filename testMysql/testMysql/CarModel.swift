//
//  CarModel.swift
//  testMysql
//
//  Created by Артем Закиров on 09.03.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

class CarModel: NSObject {
    var car_id: Int?
    var car_name: String?
    var car_year: Int?
    var car_number: String?
    var car_karaoke: Int?
    var car_owner: Int?
    var car_color: String?
    var car_group: Int?
    var car_is_activ: Int?
    var car_is_change: Int?
    
    
    
    override init() {
        
    }
    
    init(car_id: Int, car_name: String, car_year: Int, car_number: String, car_karaoke: Int,
         car_owner: Int, car_color: String, car_group: Int, car_is_activ: Int, car_is_change: Int) {
        self.car_id = car_id
        self.car_name = car_name
        self.car_year = car_year
        self.car_number = car_number
        self.car_karaoke = car_karaoke
        self.car_owner = car_owner
        self.car_color = car_color
        self.car_group = car_group
        self.car_is_activ = car_is_activ
        self.car_is_change = car_is_change
    }
}
