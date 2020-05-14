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
    
    func writeOrder(){
        ref.child("orders").child("2").setValue(["car_name": priceArr.first?.name, "start_date": "21-05-2020"])
    }
}
