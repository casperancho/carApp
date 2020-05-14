//
//  ProfileViewController.swift
//  Diplom_beta
//
//  Created by Артем Закиров on 20.02.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem!.title = "Профиль"
    }
}
