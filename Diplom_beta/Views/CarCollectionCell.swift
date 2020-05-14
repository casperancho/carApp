//
//  CarCollectionCell.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 05.05.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit
import SnapKit

class CarCollectionCell: UICollectionViewCell {
    let mainView = UIView()
    let carImageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func prepareView() {
        addSubview(mainView)
        mainView.snp.makeConstraints{ make in
            make.size.equalToSuperview()
        }
        mainView.backgroundColor = .magenta
        
        mainView.addSubview(carImageView)
        carImageView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().inset(50)
            make.width.equalToSuperview().inset(20)
        }
        carImageView.backgroundColor = .white
        
        mainView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{ make in
            make.top.equalTo(carImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(carImageView)
            make.height.equalTo(20)
        }
    }
    
    func updateName(name: String){
        nameLabel.text = name
        nameLabel.textAlignment = .center
    }
    
    override func layoutSubviews() { //очень красиво тень
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 9
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 8)
        
        self.clipsToBounds = false
    }
}
