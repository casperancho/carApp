//
//  NetworkModule.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 03.03.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

protocol Downloadable : class {
    func didRecieve (data: NSArray)
}

class NetworkModule : NSObject, URLSessionDataDelegate {
    
    weak var delegate : Downloadable!
    let urlPath : String = "http://localhost:3000"
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    
    func parseJSON (_ data: Data) {
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        var jsonElement = NSDictionary()
        var cars = NSMutableArray()
        
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let car = CarModel()
            
            if let car_id = jsonElement["car_id"] as? Int,
                let car_name = jsonElement["car_name"] as? String,
                let car_year = jsonElement["car_year"] as? Int,
                let car_number = jsonElement["car_number"] as? String,
                let car_karaoke = jsonElement["car_karaoke"] as? Int,
                let car_owner = jsonElement["car_owner"] as? Int,
                let car_color = jsonElement["car_color"] as? String,
                let car_group = jsonElement["car_groop"] as? Int,
                let car_is_activ = jsonElement["car_is_activ"] as? Int,
                let car_is_change = jsonElement["car_is_change"] as? Int
            {
                car.car_id = car_id
                car.car_name = car_name
                car.car_year = car_year
                car.car_number = car_number
                car.car_karaoke = car_karaoke
                car.car_owner = car_owner
                car.car_color = car_color
                car.car_group = car_group
                car.car_is_activ = car_is_activ
                car.car_is_change = car_is_change
            }
            cars.add(car)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.didRecieve(data: cars)
        })
        
    }
}
