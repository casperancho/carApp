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
import RealmSwift
import Realm

class FireBaseDataModel {
    
    let mayDateString = "2020-05-16 23:52:00"
    let formatter = DateFormatter()
    
    struct carPicture {
        var name = ""
        var colors: [String: String] = [:]
    }
    
    var marksUrl: [String : String] = [:]
    var ref: DatabaseReference!
    var tabView: UITableView?
    var dependsView: UIView?
    var priceArr: [carPrice] = []
    var selectedCar = carPrice()
    var pictures: [carPicture] = []
    var rentOrders: [RentOrder] = []
    var picturesDownloaded = false
    
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
        let realm = try! Realm()
        let d = realm.objects(RealmUser.self)
        let client = d.first!
        
        let now = Date()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let mayDate = formatter.date(from: mayDateString)
        let timeStamp = Int(now.timeIntervalSince(mayDate!)/2)
        ref.child("orders").child("\(timeStamp)").setValue(["car_name":order.car_name, "fio": order.fio,
                                                            "phoneNumber": order.phoneNumber,
                                                            "startDate": order.startDate,
                                                            "endDate": order.endDate,
                                                            "startPlace": order.startPlace, "price": order.price, "clientId": client.user_id])

        if client.phone_number.isEmpty && client.user_name.isEmpty {
            try! realm.write {
                client.phone_number = order.phoneNumber
                client.user_name = order.fio.components(separatedBy: " ").first!
                client.user_surname = order.fio.components(separatedBy: " ").last!
                client.orders.append(String(timeStamp))
            }
        } else {
            try! realm.write {
                client.orders.append(String(timeStamp))
            }
        }
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
    
    func downloadPictures() {
        var pics = pictures
        ref = Database.database().reference()
        ref.child("carPictures").observe(.value, with: { snapshot in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                guard let dict = snap.value as? [String : AnyObject] else {
                    return
                }
                var pic = carPicture()
                pic.name = snap.key
                for item in dict{
                    pic.colors[item.key] = item.value as! String
                }
                pics.append(pic)
            }
            self.pictures = pics
            self.picturesDownloaded = true
        })
    }
    
    func findPicture(for car: CarModel) -> String{
        for pics in pictures {
            if pics.name.replacingOccurrences(of: " ", with: "") ==
                car.car_name?.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "") {
                return pics.colors[(car.car_color?.lowercased())!]!
            }
        }
        return ""
    }
    
    func findLastUserid(){
        ref = Database.database().reference()
        ref.child("clients").observe(.value, with: { snapshot in
            let realm = try! Realm()
            if (realm.objects(RealmUser.self).isEmpty) {
                try! realm.write {
                    let user = RealmUser()
                    let snp = snapshot.children.allObjects as! [DataSnapshot]
                    user.user_id = Int(snp.last!.key)! + 1
                    realm.add(user)
                }
            }
        })
    }
    
    func createNewClient(user: RealmUser){
        ref = Database.database().reference()
        ref.child("clients").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.hasChild(String(user.user_id)) {
                print(true)
            } else {
                print(false)
            }
            
        })
    }
    
    func getOrdersOf(user: Int){
        var result: [RentOrder] = []
        ref = Database.database().reference()
        ref.child("orders").observe(.value, with: { snapshot in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                guard let dict = snap.value as? [String : AnyObject] else {
                    return
                }
                if (dict["clientId"] != nil) {
                    if (dict["clientId"] as! Int == user) {
                        let order = RentOrder(
                            car_name: dict["car_name"] as! String,
                            fio: dict["fio"] as! String,
                            phoneNumber: dict["phoneNumber"] as! String,
                            startDate: dict["startDate"] as! String,
                            endDate: dict["endDate"] as! String,
                            price: dict["price"] as! String,
                            startPlace: dict["startPlace"] as! String,
                            clientId: dict["clientId"] as! Int,
                            orderId: snap.key )
                        result.append(order)
                    }
                }
            }
            self.rentOrders = result
            self.tabView?.reloadData()
        })
    }
    
    func getPrices(of carName: String) -> carPrice{
        for price in priceArr {
            if ((price.name == carName.replacingOccurrences(of: ".", with: "")) || (price.name == carName.replacingOccurrences(of: ". ", with: ""))) {
                return price
            }
        }
        return carPrice()
    }
}
