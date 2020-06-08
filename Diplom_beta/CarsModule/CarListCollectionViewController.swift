//
//  CarListCollectionViewController.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 20.02.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit
import SnapKit

class CarListCollectionViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var carD: CarData?
    var segmentedControl = UISegmentedControl(items: ["Иконки", "Список"])
    var tabView = UITableView()
    
    
    var collView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var flowLayout = UICollectionViewFlowLayout()
    var label = UILabel()
    
    var fireBase: FireBaseDataModel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(carData: CarData, fb: FireBaseDataModel) {
        fireBase = fb
        carD = carData
        super.init(nibName: nil, bundle: nil)
    }
    

    
    override func viewDidLoad() {
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl

        
        view.backgroundColor = .white
        segmentedControl.contentVerticalAlignment = .center
        segmentedControl.addTarget(self, action: #selector(changeChoose(sender:)), for: .valueChanged)
        
        tabView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tabView.delegate = self
        tabView.dataSource = self
        
        collView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collView.register(CarCollectionCell.self, forCellWithReuseIdentifier: "CollCell")
        collView.delegate = self
        collView.dataSource = self
        showCollectionView()
        
        
    }
    
    func updateDataOf (cars: FilteredCarData) {
        tabView.reloadData()
        collView.reloadData()
    }
    
    
    @objc func changeChoose (sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            prepareCollectionView()
        case 1:
            prepareCarList()
        default:
            break
        }
    }
    
    func prepareCollectionView(){
        tabView.removeFromSuperview()
        showCollectionView()
        
    }
    
    func showCollectionView() {
        view.addSubview(collView)
        collView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.center.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }
        collView.backgroundColor = .red
        flowLayout.scrollDirection = .horizontal
        collView.showsHorizontalScrollIndicator = false
        
        view.backgroundColor = .red
        view.addSubview(label)
        label.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collView.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        label.text = "1 из \(carD!.selectedBrandCars.count)"
        label.textAlignment = .center
        label.textColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
       
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (carD?.selectedBrandCars.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCell", for: indexPath) as! CarCollectionCell
        var url = ""
        switch fireBase!.picturesDownloaded {
        case true:
            url = fireBase!.findPicture(for: (carD?.selectedBrandCars[indexPath.section])!)
        case false:
            url = ""
        }
        collCell.updateName(name: (carD?.selectedBrandCars[indexPath.section].car_name)!)
        collCell.updatePhoto(url: url)
        return collCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collView.visibleCells {
            let indexPath = collView.indexPath(for: cell)
            label.text = "\(indexPath!.section+1) из \(carD!.selectedBrandCars.count)"
            label.textAlignment = .center
            label.textColor = .white
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.height/3, height: view.frame.size.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: view.frame.size.height/4, left: view.frame.width/8, bottom: view.frame.size.height/4, right: view.frame.width/8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SingleCarViewController(car: (carD?.selectedBrandCars[indexPath.section])!, shouldChose: true)
        var url = ""
        switch fireBase!.picturesDownloaded {
        case true:
            url = fireBase!.findPicture(for: (carD?.selectedBrandCars[indexPath.section])!)
        case false:
            url = ""
        }
        vc.updatePhoto(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func prepareCarList(){
        collView.removeFromSuperview()
        showTableView()
    }
    
    func showTableView(){
        view.addSubview(tabView)
        tabView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (carD?.selectedBrandCars.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = "\(carD!.selectedBrandCars[indexPath.row].car_name!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SingleCarViewController(car: (carD?.selectedBrandCars[indexPath.row])!, shouldChose: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}
