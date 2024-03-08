//
//  TabBarView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit

protocol TabBarViewProtocol: AnyObject {
    func setControllers(controllers: [UIViewController])
}

class TabBarView: UITabBarController {
    
    var presenter: TabBarPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
    }

}

extension TabBarView: TabBarViewProtocol {
    
    func setControllers(controllers: [UIViewController]) {
        tabBarController?.setViewControllers(controllers, animated: true)
    }
    
}
