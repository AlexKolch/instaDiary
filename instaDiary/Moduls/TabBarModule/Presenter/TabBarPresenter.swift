//
//  TabBarPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit

protocol TabBarPresenterProtocol: AnyObject {
    init(view: TabBarViewProtocol)
    func buildTabBar()
}

class TabBarPresenter {
    
    weak var view: TabBarViewProtocol?
    
    required init(view: TabBarViewProtocol) {
        self.view = view
        buildTabBar()
    }
    
}

extension TabBarPresenter: TabBarPresenterProtocol {
    
    func buildTabBar() {
        view?.setControllers(controllers: [])
    }
    
}
