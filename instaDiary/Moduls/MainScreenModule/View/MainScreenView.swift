//
//  MainScreenView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit

protocol MainScreenViewProtocol: AnyObject {
    func showPost()
}

class MainScreenView: UIViewController {
    var presener: MainScreenPresenter!
}

extension MainScreenView: MainScreenViewProtocol {
    
    func showPost() {
        //обновляем коллекцию
    }
    
}
