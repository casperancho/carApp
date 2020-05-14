//
//  FilterDataModule.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 01.05.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

struct FilteredCarData {
    var name: String
    var property: [String: Any] = [:]
    var arrayOf: [[String: Any]] = [[:]]
    
    mutating func addProperty(car:CarModel) {
        if arrayOf[0].values.count == 0 { arrayOf = arrayOf.dropLast() }
            var newCar = FilteredCarData(name: car.car_name!)
            newCar.property["id"] = car.car_id
            newCar.property["year"] = car.car_year
            newCar.property["number"] = car.car_number
            newCar.property["karaoke"] = car.car_karaoke
            newCar.property["owner"] = car.car_owner
            newCar.property["color"] = car.car_color
            newCar.property["group"] = car.car_group
            newCar.property["is_active"] = car.car_is_activ
            newCar.property["is_change"] = car.car_is_change
            arrayOf.append(newCar.property)
    }    
}
