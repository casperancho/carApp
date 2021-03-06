//
//  OrderViewController.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 20.02.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class OrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var cars: CarData? = nil
    let realm = try! Realm()
    var selectedCarIndex = 0
    
    let headerText = UITextField()
    let scrollView = UIScrollView()
    let nameLabel = UILabel()
    let nameTextInput = UITextField()
    let surnameLabel = UILabel()
    let surnameTextInput = UITextField()
    let phoneLabel = UILabel()
    let phoneTextInput = UITextField()
    
    let carBrandPickerLabel = UILabel()
    let carBrandPicker = UIPickerView()
    let carModelPickerLabel = UILabel()
    let carModelPicker = UIPickerView()
    let checkCarButton = UIButton()
    
    let startDateLabel = UILabel()
    let endDateLabel = UILabel()
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    let numberField = UITextField()
    let startAddresField = UITextField()
    let startAddresLabel = UILabel()
    let priceLabel = UILabel()
    
    
    let createOrderButton = UIButton()
    var order = RentOrder()
    var client = RealmUser()
    var formatter = DateFormatter()
    let fireBase = FireBaseDataModel()
    var user = RealmUser()
    
    override func viewDidLoad() {
        let usr = realm.objects(RealmUser.self).first
        if usr != nil {
            user = usr!
            print(usr)
        }
        
        let carD = CarData()
        cars = carD
        cars?.realmExtracting()
        cars?.filterData()
        cars?.selectBrand(index: 0)
        prepareView()
        fireBase.downloadPrices()
        fireBase.downloadPictures()
        dateChanged(picker: startDatePicker)
        
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem!.title = "Заказать автомобиль"

    }
 
    func prepareView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1500)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollView.backgroundColor = .systemBackground
        
        scrollView.addSubview(headerText)
        headerText.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        headerText.text = "Введите данные для создания заявки на аренду"
        headerText.textAlignment = .center
        headerText.font = UIFont(name: "Georgia", size: 15)
        
        scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{ make in
            make.top.equalTo(headerText.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        nameLabel.text = "Имя"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Georgia", size: 20)

        
        scrollView.addSubview(nameTextInput)
        nameTextInput.snp.makeConstraints{ make in
            make.top.equalTo(headerText.snp.bottom).offset(20)
            make.left.equalTo(nameLabel.snp.right).offset(15)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        nameTextInput.backgroundColor = .white
        if (user.user_id != -1) {
            nameTextInput.text = user.user_name
        }
        nameTextInput.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        nameTextInput.layer.borderWidth = 1.0
        nameTextInput.layer.cornerRadius = 5.0
        
        scrollView.addSubview(surnameLabel)
        surnameLabel.snp.makeConstraints{ make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        surnameLabel.text = "Фамилия"
        surnameLabel.textAlignment = .center
        surnameLabel.font = UIFont(name: "Georgia", size: 20)
        
        scrollView.addSubview(surnameTextInput)
        surnameTextInput.snp.makeConstraints{ make in
            make.top.equalTo(nameTextInput.snp.bottom).offset(20)
            make.left.equalTo(surnameLabel.snp.right).offset(15)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        surnameTextInput.backgroundColor = .white
        if (user.user_id != -1) {
            surnameTextInput.text = user.user_surname
        }
        surnameTextInput.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        surnameTextInput.layer.borderWidth = 1.0
        surnameTextInput.layer.cornerRadius = 5.0
        
        scrollView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints{ make in
            make.top.equalTo(surnameLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        phoneLabel.text = "Номер телефона"
        phoneLabel.textAlignment = .center
        phoneLabel.font = UIFont(name: "Georgia", size: 20)
        
        scrollView.addSubview(phoneTextInput)
        phoneTextInput.snp.makeConstraints{ make in
            make.top.equalTo(surnameTextInput.snp.bottom).offset(20)
            make.left.equalTo(phoneLabel.snp.right).offset(15)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        phoneTextInput.backgroundColor = .white
        if (user.user_id != -1) {
            phoneTextInput.text = user.phone_number
        }
        phoneTextInput.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        phoneTextInput.layer.borderWidth = 1.0
        phoneTextInput.layer.cornerRadius = 5.0
        /*
         ON EDIT event
         private func formatPhone(_ number: String) -> String {
             let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
             let format: [Character] = ["X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]

             var result = ""
             var index = cleanNumber.startIndex
             for ch in format {
                 if index == cleanNumber.endIndex {
                     break
                 }
                 if ch == "X" {
                     result.append(cleanNumber[index])
                     index = cleanNumber.index(after: index)
                 } else {
                     result.append(ch)
                 }
             }
             return result
         }
         */
        
        scrollView.addSubview(carBrandPickerLabel)
        carBrandPickerLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(phoneLabel.snp.bottom).offset(70)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        carBrandPickerLabel.text = "Марка"
        carBrandPickerLabel.textAlignment = .center
        carBrandPickerLabel.font = UIFont(name: "Georgia", size: 20)
        
        scrollView.addSubview(carBrandPicker)
        carBrandPicker.snp.makeConstraints{ make in
            make.left.equalTo(carBrandPickerLabel.snp.right).offset(20)
            make.top.equalTo(phoneTextInput.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(100)
        }
        carBrandPicker.delegate = self
        carBrandPicker.dataSource = self
        carBrandPicker.tag = 1
        
        scrollView.addSubview(carModelPickerLabel)
        carModelPickerLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(carBrandPicker.snp.bottom).offset(70)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        carModelPickerLabel.text = "Модель"
        carModelPickerLabel.textAlignment = .center
        carModelPickerLabel.font = UIFont(name: "Georgia", size: 20)
        
        scrollView.addSubview(carModelPicker)
        carModelPicker.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(carModelPickerLabel.snp.bottom).offset(10)
            make.width.equalTo(550)
            make.height.equalTo(100)
        }
        carModelPicker.delegate = self
        carModelPicker.dataSource = self
        carModelPicker.tag = 2
        
        scrollView.addSubview(checkCarButton)
        checkCarButton.snp.makeConstraints{ make in
            make.top.equalTo(carModelPicker.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        checkCarButton.setTitle("Осмотреть машину", for: .normal)
        checkCarButton.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 20)
        checkCarButton.titleLabel?.textAlignment = .center
        checkCarButton.backgroundColor = .white
        checkCarButton.setTitleColor(.black, for: .normal)
        checkCarButton.addTarget(self, action: #selector(self.checkButtonClicked(sender:)), for: .touchUpInside)
        
        scrollView.addSubview(startDateLabel)
        startDateLabel.snp.makeConstraints{ make in
            make.top.equalTo(checkCarButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(20)
        }
        startDateLabel.text = "Дата начала аренды"
        startDateLabel.textAlignment = .center
        startDateLabel.font = UIFont(name: "Georgia", size: 20)
        
        scrollView.addSubview(startDatePicker)
        startDatePicker.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startDateLabel.snp.bottom).offset(10)
        }
        startDatePicker.datePickerMode = .date
        startDatePicker.minimumDate = Date()
        startDatePicker.addTarget(self, action: #selector(dateChanged(picker:)), for: .valueChanged)
        
        scrollView.addSubview(endDateLabel)
        endDateLabel.snp.makeConstraints{ make in
            make.top.equalTo(startDatePicker.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(20)
        }
        endDateLabel.text = "Дата окончания аренды"
        endDateLabel.textAlignment = .center
        endDateLabel.font = UIFont(name: "Georgia", size: 20)
        
        scrollView.addSubview(endDatePicker)
        endDatePicker.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(endDateLabel.snp.bottom).offset(10)
        }
        endDatePicker.datePickerMode = .date
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        endDatePicker.addTarget(self, action: #selector(dateChanged(picker:)), for: .valueChanged)
        
        scrollView.addSubview(startAddresLabel)
        startAddresLabel.snp.makeConstraints{ make in
            make.top.equalTo(endDatePicker.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        startAddresLabel.text = "Место подачи автомобиля:"
        startAddresLabel.font = UIFont(name: "Georgia", size: 20)
        
        scrollView.addSubview(startAddresField)
        startAddresField.snp.makeConstraints{ make in
            make.top.equalTo(startAddresLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        startAddresField.backgroundColor = .white
        startAddresField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        startAddresField.layer.borderWidth = 1.0
        startAddresField.layer.cornerRadius = 5.0
        startAddresField.contentVerticalAlignment = .top
        
        scrollView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
            make.width.equalTo(300)
            make.top.equalTo(startAddresField.snp.bottom).offset(30)
        }
        priceLabel.text = "Стоимость: "
        priceLabel.textColor = .black
        priceLabel.font = UIFont(name: "Georgia", size: 20)
        
        scrollView.addSubview(createOrderButton)
        createOrderButton.snp.makeConstraints{ make in
            make.top.equalTo(priceLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        createOrderButton.setTitle("Оставить заявку", for: .normal)
        createOrderButton.titleLabel?.textAlignment = .center
        createOrderButton.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 20)
        createOrderButton.backgroundColor = .white
        createOrderButton.setTitleColor(.black, for: .normal)
        createOrderButton.addTarget(self, action: #selector(self.createButtonClicked(sender:)), for: .touchUpInside)
        
    }
    
    @objc func checkButtonClicked(sender: UIButton!) {
        let vc = SingleCarViewController(car: (cars!.selectedBrandCars[selectedCarIndex]), shouldChose: false)
        var url = ""
        switch fireBase.picturesDownloaded {
        case true:
            url = fireBase.findPicture(for: cars!.selectedBrandCars[selectedCarIndex])
        case false:
            url = ""
        }
        vc.updatePhoto(url: url)
        vc.fireBase = fireBase
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createButtonClicked(sender: UIButton!) {
        
        var alertText = ""
        if cars!.selectedBrandCars[selectedCarIndex].car_name! == "" { alertText += "Выберете автомобиль\n" }
        if nameTextInput.text == "" { alertText += "Введите имя\n" }
        if surnameTextInput.text == "" { alertText += "Введите фамилию\n" }
        if phoneTextInput.text == "" { alertText += "Введите номер телефона" }
        
        if !alertText.isEmpty {
            let alert = UIAlertController(title: "Введите корректно данные", message: alertText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            order.car_name = cars!.selectedBrandCars[selectedCarIndex].car_name!
            order.fio = "\((nameTextInput.text ?? "")) \(surnameTextInput.text ?? "")"
            order.phoneNumber = "\(phoneTextInput.text ?? "")"

            order.startDate = formatter.string(from: startDatePicker.date)
            order.endDate = formatter.string(from: endDatePicker.date)
            order.price = fireBase.priceCounting(car: cars!.selectedBrandCars[selectedCarIndex].car_name!,
                                             start: startDatePicker.date,
                                             end: endDatePicker.date)
            order.startPlace = startAddresField.text ?? ""
            fireBase.writeOrder(order: order)
            let alert = UIAlertController(title: "Заказ успешно создан", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Пройти в личный кабинет", style: UIAlertAction.Style.default, handler: { action in
                self.tabBarController?.selectedIndex = 2
            }))
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1: return cars!.brandList.count
            
        case 2: if cars?.selectedBrandIndex == -1 {
            return 1
        } else {
            return cars!.selectedBrandCars.count
            }
        default: return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1: return cars?.brandList[row]
        case 2: if cars?.selectedBrandIndex == -1 {
            return "Выберите марку"
        } else {
            return formatString(car: (cars?.selectedBrandCars[row])!)
            }
        default: return "no data"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            cars?.selectBrand(index: row)
            carModelPicker.reloadAllComponents()
            selectedCarIndex = 0
        case 2:
            selectedCarIndex = row
        default: break
        }
        dateChanged(picker: startDatePicker)
    }

    func formatString(car:CarModel) -> String {
        if car.car_karaoke == 0 {
            return "\(car.car_name! + " " + car.car_color!)"
        } else {
            return "\(car.car_name! + " "  + car.car_color! + ".Караоке")"
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dateChanged(picker: UIDatePicker) {
        priceLabel.text = "Стоимость: \(fireBase.priceCounting(car: cars!.selectedBrandCars[selectedCarIndex].car_name!, start: startDatePicker.date, end: endDatePicker.date))"
    }
}

