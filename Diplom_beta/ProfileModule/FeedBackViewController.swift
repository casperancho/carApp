//
//  FeedBackViewController.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 08.06.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit
import SnapKit

class FeedBackViewController: UIViewController {
    
    let titleLabel = UILabel()
    let feedBackTextInput = UITextField()
    let sendButton = UIButton()

    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        prepareView()
    }
    
    func prepareView(){
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(400)
            make.height.equalTo(20)
        }
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Georgia-Bold", size: 13)
        titleLabel.text = "Оставить отзыв о работе сервиса можете в окне ниже:"
        
        view.addSubview(feedBackTextInput)
        feedBackTextInput.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(400)
            make.height.equalTo(300)
        }
        feedBackTextInput.backgroundColor = .white
        feedBackTextInput.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        feedBackTextInput.layer.borderWidth = 1.0
        feedBackTextInput.layer.cornerRadius = 5.0
        feedBackTextInput.contentVerticalAlignment = .top
    
    view.addSubview(sendButton)
        sendButton.snp.makeConstraints{ make in
            make.top.equalTo(feedBackTextInput.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        sendButton.setTitle("Оставить отзыв", for: .normal)
        sendButton.titleLabel?.textAlignment = .center
        sendButton.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 20)
        sendButton.backgroundColor = .white
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.addTarget(self, action: #selector(self.sendButtonClicked(sender:)), for: .touchUpInside)
        
    }
    
    @objc func sendButtonClicked(sender: UIButton!) {
        let alert = UIAlertController(title: "Спасибо за отзыв", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
