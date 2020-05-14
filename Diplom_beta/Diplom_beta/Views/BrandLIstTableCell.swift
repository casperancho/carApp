//
//  BrandLIstTableCell.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 05.05.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage
import Alamofire

class BrandLIstTableCell: UITableViewCell {
    
    let mainView = UIView()
    let nameLabel = UILabel()
    let brandImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func prepareCell(){
        addSubview(mainView)
        mainView.snp.makeConstraints{ make in
            make.size.equalToSuperview()
        }
        mainView.backgroundColor = .red
        
        mainView.addSubview(brandImageView)
        brandImageView.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.equalToSuperview().inset(10)
            make.width.equalTo(200)
        }
        brandImageView.backgroundColor = .white
        
        mainView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{ make in
            make.left.equalTo(brandImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(40)
            make.right.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    
    func updateData(name: String, and url: String){
        updateName(name: name)
        updateImage(with: url)
    }
    
    func updateName(name: String){
        nameLabel.text = name
    }
    
    func updateImage(with url: String){
        brandImageView.af_setImage(withURL: URL(string: url)!)
    }
}