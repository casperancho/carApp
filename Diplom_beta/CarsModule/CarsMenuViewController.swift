//
//  CarsMenuViewController.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 19.03.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import Realm

class CarsMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Downloadable {
 
    let realm = try! Realm()
    var menuTableView = UITableView()
    var carD = CarData()
    var fireBase = FireBaseDataModel()
    
    override func viewDidLoad() {
        print(realm.configuration.fileURL!)
        let networkModule = NetworkModule()
        networkModule.delegate = self
        networkModule.downloadItems()
        
        view.backgroundColor = .white
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(BrandLIstTableCell.self, forCellReuseIdentifier: "menuCell")
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints{ make in
            make.size.equalToSuperview()
        }
        
        fireBase.getMarksPhoto()
        fireBase.tabView = menuTableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem!.title = "Марки автомобилей"
    }
    
    func didRecieve(data: NSArray) {
        carD.updateArrayOf(cars: data)
        carD.filterData()
        carD.realmFilling()
        menuTableView.reloadData()
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carD.brandList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! BrandLIstTableCell
        let car = carD.brandList[indexPath.row]
        let url = fireBase.searchUrlFor(car: car)
        cell.updateData(name: car, and: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = CarListCollectionViewController(carData: carD)
        carD.selectBrand(index: indexPath.row)
        navigationController?.pushViewController(VC, animated: true)        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
