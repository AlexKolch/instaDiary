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
    
    var presenter: TabBarPresenterProtocol!
    let tabs: [UIImage] = [.home, .plus, .heart]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        self.tabBar.isHidden = true
        ///создание кнопок таббара
        tabs.enumerated().forEach {
            let offset: [Double] = [-100, 0, 100]
            
            let tabButton = createTabBarBtn(icon: $0.element, tag: $0.offset, offsetX: offset[$0.offset], isBigBtn: $0.offset == 1 ? true : false)
            
            view.addSubview(tabButton)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedIndex = 2 //Для показа favorite view по умолчанию
    }

    lazy var selectItem = UIAction { [weak self] sender in
        guard
            let self = self,
            let sender = sender.sender as? UIButton
        else {return}
        
        self.selectedIndex = sender.tag
    }
}

extension TabBarView {
    
    private func createTabBarBtn(icon: UIImage, tag: Int, offsetX: Double, isBigBtn: Bool = false) -> UIButton {
        return {
            let btnSize = isBigBtn ? 60.0 : 25.0
            $0.frame.size = CGSize(width: btnSize, height: btnSize)
            $0.tag = tag
            $0.setBackgroundImage(icon, for: .normal)
            $0.frame.origin = CGPoint(x: .zero, y: view.frame.height - (btnSize + (isBigBtn ? 44 : 62)))
            $0.center.x = view.center.x + offsetX
            return $0
        }(UIButton(primaryAction: selectItem))
    }
}

extension TabBarView: TabBarViewProtocol {
    
    func setControllers(controllers: [UIViewController]) {
        setViewControllers(controllers, animated: true)
    }
    
}
