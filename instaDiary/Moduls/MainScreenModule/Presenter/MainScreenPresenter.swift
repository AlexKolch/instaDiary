//
//  MainScreenPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit

protocol MainScreenPresenterProtocol: AnyObject {
    init(view: MainScreenViewProtocol)
}

class MainScreenPresenter: MainScreenPresenterProtocol {
    
    weak var view: MainScreenViewProtocol?
    
    required init(view: MainScreenViewProtocol) {
        self.view = view
    }
    
    
}
