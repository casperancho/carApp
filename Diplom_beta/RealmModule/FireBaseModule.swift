//
//  FireBaseModule.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 13.05.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class FireBaseDataModel {
    
    let mayDateString = "2020-05-16 23:52:00"
    let formatter = DateFormatter()

    struct carPrice {
        var name = ""
        var budn = 0
        var frd = 0
        var sat = 0
    }
    
    var marksUrl: [String : String] = [:]
    var ref: DatabaseReference!
    var tabView: UITableView?
    var priceArr: [carPrice] = []
    var selectedCar = carPrice()
    
    func getMarksPhoto(){
        var marks: [String : String] = [:]
        ref = Database.database().reference()
        ref.child("marks").observeSingleEvent(of: .value, with: { snapshot in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                guard let dict = snap.value as? [String: String] else {
                    return
                }
                marks[snap.key] = dict["logo"]!
            }
            self.marksUrl = marks
            self.tabView?.reloadData()
        })
    }
    
    func searchUrlFor(car: String) -> String {
        return marksUrl["\(car)"] ?? "https://i.pinimg.com/originals/10/b2/f6/10b2f6d95195994fca386842dae53bb2.png"
    }
    
    
    func downloadPrices() {
        var prices = priceArr
        ref = Database.database().reference()
        ref.child("prices").observe(.value, with: { snapshot in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                guard let dict = snap.value as? [String : AnyObject] else {
                    return
                }
                var car = carPrice()
                car.name = snap.key
                for items in dict {
                    switch items.key {
                    case "frd":
                        car.frd = items.value as! Int
                    case "sat":
                        car.sat = items.value as! Int
                    case "budn":
                        car.budn = items.value as! Int
                    default:
                        continue
                    }
                }
                prices.append(car)
            }
            self.priceArr = prices
        })
    }
    
    func writeOrder(order: RentOrder){
        let now = Date()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let mayDate = formatter.date(from: mayDateString)
        let timeStamp = Int(now.timeIntervalSince(mayDate!)/2)
        ref.child("orders").child("\(timeStamp)").setValue(["car_name":order.car_name, "fio": order.fio,
                                                            "phoneNumber": order.phoneNumber,
                                                            "startDate": order.startDate,
                                                            "endDate": order.endDate,
                                                            "startPlace": order.startPlace, "price": order.price])
    }
    
    func priceCounting(car: String, start: Date, end: Date) -> String {
        if !(selectedCar.name == car.replacingOccurrences(of: ".", with: "")) {
            for item in priceArr {
                if (item.name == car.replacingOccurrences(of: ".", with: "")) {
                    selectedCar = item
                    break
                }
            }
        }
        
        var startDateHelper = start
        var priceSum = 0
        while startDateHelper < end {
            switch Calendar.current.component(.weekday, from: startDateHelper) {
            case 1...6:
                priceSum += selectedCar.budn
            case 7:
                priceSum += selectedCar.sat
            default:
                continue
            }
            startDateHelper = Calendar.current.date(byAdding: .day, value: 1, to: startDateHelper)!
        }
        return "\(priceSum)"
    }
    
}
