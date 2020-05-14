//
//  ViewController.swift
//  testMysql
//
//  Created by Артем Закиров on 03.03.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Downloadable, UITableViewDelegate, UITableViewDataSource {
    
    var carItems : NSArray = NSArray()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        let carModel = Network()
        carModel.delegate = self
        carModel.downloadItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func didRecieve(data: NSArray) {
        carItems = data
        for i in 0..<carItems.count {
            let item: CarModel = carItems[i] as! CarModel
            print(item)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

