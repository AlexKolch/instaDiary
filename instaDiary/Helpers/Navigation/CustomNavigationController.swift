//
//  CustomNavigationController.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 06.08.2024.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        //Скрываем нав бар
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.setHidesBackButton(true, animated: true) //не будет работать жест смахивания страницы(можно добавить свой жест)
        navigationController?.navigationBar.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
