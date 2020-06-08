//
//  ProfileViewController.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 20.02.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SnapKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let realm = try! Realm()
    var user = RealmUser()
    let variousButton = UIButton()
    let titleLabel = UILabel()
    let ordersLabel = UILabel()
    var orderList: [RentOrder] = []
    var fireBase = FireBaseDataModel()
    var ordersTable = UITableView()
    var feedBackButton = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        let usr = realm.objects(RealmUser.self).first
        if (usr != nil) {
            view.backgroundColor = .cyan
            print(usr?.user_name)
            user = usr!
            loggedInView()
        } else {
            view.backgroundColor = .green
            defaultView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem!.title = "Профиль"
    }
    
    override func viewDidLoad() {
        ordersTable.delegate = self
        ordersTable.dataSource = self
        ordersTable.register(UITableViewCell.self, forCellReuseIdentifier: "orderCell")
    }
    
    func defaultView(){
        
    }
    
    func loggedInView(){
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo((navigationController?.navigationBar.snp.bottom)!).offset(20)
            make.width.equalTo(300)
        }
        titleLabel.text = "Здравствуйте, \(user.user_name) \(user.user_surname)"
        fireBase.getOrdersOf(user: user.user_id)
        fireBase.tabView = ordersTable
        
        view.addSubview(ordersLabel)
        ordersLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
        }
        ordersLabel.text = "Ваши заказы:"
        
        view.addSubview(ordersTable)
        ordersTable.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(ordersLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().inset(40)
            make.height.equalTo(300)
        }
        
        view.addSubview(feedBackButton)
        feedBackButton.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(ordersTable.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        feedBackButton.setTitle("Оставить отзыв", for: .normal)
        feedBackButton.titleLabel?.textAlignment = .center
        feedBackButton.backgroundColor = .white
        feedBackButton.setTitleColor(.black, for: .normal)
        feedBackButton.addTarget(self, action: #selector(self.feedBackButtonClicked(sender:)), for: .touchUpInside)
    }
    
    @objc func feedBackButtonClicked(sender: UIButton!) {
        var vc = FeedBackViewController()
        self.present(vc, animated: true, completion: nil)
//        self.show(vc, sender: nil)
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fireBase.rentOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
        cell.textLabel?.text = "\(fireBase.rentOrders[indexPath.row].orderId)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var alertText =
        """
        Автомобиль: \(fireBase.rentOrders[indexPath.row].car_name)\n Даты аренды: \(fireBase.rentOrders[indexPath.row].startDate)-\(fireBase.rentOrders[indexPath.row].endDate) \n Стоимость: \(fireBase.rentOrders[indexPath.row].price)
        """
        let alert = UIAlertController(title: "Данные о заказе", message: alertText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
