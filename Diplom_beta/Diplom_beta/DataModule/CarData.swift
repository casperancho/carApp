//
//  CarData.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 04.05.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CarData {
    
    var carArray : NSArray = NSArray()
    var clearCarData: [FilteredCarData] = []  //отфильтрованные автомобили
    var brandList: [String] = [] // список производителей
    var filteringIndex: Int = 0  //индекс для фильтрации
    var selectedBrandIndex: Int = -1 //номер в списке производителей
    var selectedBrandCars: [CarModel] = [] //список выбранных машин по бренду
    let realm = try! Realm()
    
    func updateArrayOf(cars: NSArray) {
        carArray = cars
    }
    
    func selectBrand(index: Int){
        selectedBrandCars = []
        selectedBrandIndex = index
        createListOfFilteringCars()
    }
    
    func filterData() {  //фильтрация по входным данным, для выявления уникальных машин
        for i in 1..<carArray.count {
            let car = carArray[i] as! CarModel
            if searchFilterName(carName: car.car_name ?? "") {
                var filter = clearCarData[filteringIndex]
                filter.addProperty(car: car)
                clearCarData[filteringIndex] = filter
            } else {
                var filter = FilteredCarData(name: car.car_name ?? "no name")
                filter.addProperty(car: car)
                clearCarData.append(filter)
            }
            makingBrandListWith(car: car.car_name ?? "")
        }
    }
    
    func searchFilterName(carName: String) -> Bool {
        for i in 0..<clearCarData.count {
            if checkSameSentenceCounOf(car1: clearCarData[i].name, car2: carName) {
                filteringIndex = i
                return true
            } else if checkSamePairNameof(car1: clearCarData[i].name, car2: carName) {
                filteringIndex = i
                return true
            }
        }
        return false
    }
    
    func checkSamePairNameof(car1: String, car2: String) -> Bool {  //сравнивает названия
        let first = car1.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "")
        let second = car2.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "")
        if first == second { return true }
        return false
    }
    
    func checkSameSentenceCounOf(car1: String, car2: String) -> Bool { //сравнивает названия если есть что-то после запятой
        let firstDiv = car1.components(separatedBy: ". ")
        let secondDiv = car2.components(separatedBy: ". ")
        
        if checkSamePairNameof(car1: firstDiv.first!, car2: secondDiv.first!) && (firstDiv.count == secondDiv.count) {
            return true
        }
        return false
    }
    
    func makingBrandListWith(car: String){  //список брендов
        var brandName = car.components(separatedBy: " ")
        if ((brandName.first! == "Роллс") || (brandName.first! == "Роллс-Ройс")) { brandName[0] = "Роллс Ройс"}
        if brandName.count == 1 {
            if !(brandList.contains(brandName.first!)) {
                brandList.append(brandName.first!)
            }
        } else {
            if !((brandList.contains(brandName.first!)) || (brandList.contains(brandName[1]))) {
                brandList.append(brandName.first!)
            }
        }
    }
    
    func createListOfFilteringCars(){   // создание списка автомобилей выбранных брендов
        var brandName = brandList[selectedBrandIndex]
        if (brandName == "Роллс Ройс") { brandName = "Роллс" }
        for cars in clearCarData {                                  //поиск совпадений имен
            let carName = cars.name.components(separatedBy: " ")
            if (carName.count == 1) {
                if (carName.first == brandName) {
                    convertToCarWith(properties: cars.arrayOf, name: cars.name)
                }
            } else {
                if ((carName[1] == brandName) || (carName.first == brandName)) {
                    convertToCarWith(properties: cars.arrayOf, name: cars.name)
                }
            }
        }
    }
    
    func convertToCarWith(properties: [[String:Any]], name: String){      //преобразование в массив машин используяю свойства
        for model in properties {
            var car = CarModel()
            car.car_name = name
            car.car_id = model["id"] as? Int
            car.car_year = model["year"] as? Int
            car.car_number = model["number"] as? String
            car.car_karaoke = model["karaoke"] as? Int
            car.car_owner = model["owner"] as? Int
            car.car_color = model["color"] as? String
            car.car_group = model["group"] as? Int
            car.car_is_activ = model["is_active"] as? Int
            car.car_is_change = model["is_change"] as? Int
            if !checkSame(car: car) {
                selectedBrandCars.append(car)
            }
        }
    }
    
    func checkSame(car: CarModel) -> Bool {
        for items in selectedBrandCars {
            if (car.car_color == items.car_color) &&
                (car.car_name == items.car_name) &&
                (car.car_karaoke == items.car_karaoke) {
                return true
            }
        }
        return false
    }
    
    func realmFilling(){
        for items in carArray {
            let car = items as! CarModel
            if !(realm.objects(RealmCar.self).filter("car_id == \(car.car_id!)").isEmpty) {
                continue
            }
            let rlmCar = RealmCar()
            rlmCar.car_color = car.car_color ?? ""
            rlmCar.car_group = car.car_group ?? 0
            rlmCar.car_id  = car.car_id ?? 0
            rlmCar.car_is_activ = car.car_is_activ ?? 0
            rlmCar.car_is_change = car.car_is_change ?? 0
            rlmCar.car_karaoke = car.car_karaoke ?? 0
            rlmCar.car_name = car.car_name ?? ""
            rlmCar.car_number = car.car_number ?? ""
            rlmCar.car_owner = car.car_owner ?? 0
            rlmCar.car_year = car.car_year ?? 0
            
            try! realm.write {
                realm.add(rlmCar)
            }
        }
    }
    
    func realmExtracting() {
        let carData = realm.objects(RealmCar.self)
        for rcar in carData {
            let car = CarModel(car_id: rcar.car_id, car_name: rcar.car_name,
                                car_year: rcar.car_year, car_number: rcar.car_number,
                                car_karaoke: rcar.car_karaoke, car_owner: rcar.car_owner,
                                car_color: rcar.car_color, car_group: rcar.car_group,
                                car_is_activ: rcar.car_is_activ, car_is_change: rcar.car_is_change)
            
            carArray = carArray.adding(car) as NSArray
        }
    }
}
