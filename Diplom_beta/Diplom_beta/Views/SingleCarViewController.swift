//
//  SingleCarViewController.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 10.05.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit
import SnapKit
import Realm
import RealmSwift

class SingleCarViewController: UIViewController {
    
    let photoView = UIView()
    let pricesView = UIView()
    
    let pricesLabel = UILabel()
    let carNameLabel = UILabel()
    let carColorLabel = UILabel()
    let carYearLabel = UILabel()
    let carKaraokeLabel = UILabel()
    let carCapacity = UILabel()
    
    let choseCarButton = UIButton()
    
    var shouldChoseCar: Bool?
    
    var car: CarModel?
    
    init(car: CarModel, shouldChose: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.car = car
        self.shouldChoseCar = shouldChose
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        prepareView()
    }
    
    func prepareView(){
        view.addSubview(photoView)
        photoView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(500)
            make.height.equalTo(300)
        }
        photoView.backgroundColor = .cyan
        
        view.addSubview(carNameLabel) //name
        carNameLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(photoView.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        carNameLabel.text = getCorrectNameOf(car: car!.car_name!)
        
        view.addSubview(carCapacity) //количество мест
        carCapacity.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(carNameLabel.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        carCapacity.text = "\(getCapacityOf(car: car!.car_name!)) мест"
        
        view.addSubview(carColorLabel) // color
        carColorLabel.snp.makeConstraints{ make in
            make.top.equalTo(carCapacity.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        carColorLabel.text = "Цвет: \(car!.car_color!)"
        
        view.addSubview(carYearLabel) //year
        carYearLabel.snp.makeConstraints{ make in
            make.top.equalTo(carColorLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        if car?.car_year == 0 {
            carYearLabel.text = "Год: Нет данных"
        } else {
            carYearLabel.text = "Год: \(car!.car_year!)г."
        }
        
        view.addSubview(carKaraokeLabel) //karaoke
        carKaraokeLabel.snp.makeConstraints{ make in
            make.top.equalTo(carYearLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        if car?.car_karaoke == 0 {
            carKaraokeLabel.text = "Караоке: Нет"
        } else {
            carKaraokeLabel.text = "Караоке: Есть"
        }
        
        view.addSubview(pricesView)
        pricesView.snp.makeConstraints{ make in
            make.top.equalTo(carKaraokeLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(500)
            make.height.equalTo(300)
        }
        pricesView.backgroundColor = .magenta
        
        if shouldChoseCar! {
            view.addSubview(choseCarButton)
            choseCarButton.snp.makeConstraints{ make in
                make.top.equalTo(pricesView.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.height.equalTo(30)
                make.width.equalTo(500)
            }
            choseCarButton.setTitle("Выбрать машину", for: .normal)
            choseCarButton.titleLabel?.textAlignment = .center
            choseCarButton.backgroundColor = .white
            choseCarButton.setTitleColor(.black, for: .normal)
        }
    }
    
    func getCorrectNameOf(car: String) -> String {
        return car.replacingOccurrences(of: "\(getCapacityOf(car: car))м.", with: "").replacingOccurrences(of: "\(getCapacityOf(car: car))м", with: "")
    }
    
    func getCapacityOf(car: String) -> String {
        let carAr = car.components(separatedBy: " ")
        var result = ""
        for el in carAr {
            if el.contains("м.") || el.contains("м") {
                for s in el.components(separatedBy: CharacterSet.decimalDigits.inverted) {
                    if s != "" {
                        result += s
                        result += "-"
                    }
                }
            }
        }
        if result.last == "-" { result.removeLast() }
        return result
    }
    
}
