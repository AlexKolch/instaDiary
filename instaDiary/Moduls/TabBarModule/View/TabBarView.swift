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
    
    ///положим на эту вью таб бар кнопки чтобы легче было ими управлять при скрытии бара
    private lazy var tabBarView: UIView = {
        return $0
    }(UIView(frame: CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 60)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideTabBar), name: .hideTabBar, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToMainView), name: .goToMain, object: nil)
        
        view.backgroundColor = .appMain
        self.tabBar.isHidden = true
        ///создание кнопок таббара
        tabs.enumerated().forEach {
            let offset: [Double] = [-100, 0, 100]
            let tabButton = createTabBarBtn(icon: $0.element, tag: $0.offset, offsetX: offset[$0.offset], isBigBtn: $0.offset == 1 ? true : false)
            
            tabBarView.addSubview(tabButton)
        }
        view.addSubview(tabBarView)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        selectedIndex = 0
//    }

    lazy var selectItem = UIAction { [weak self] sender in
        guard
            let self = self,
            let sender = sender.sender as? UIButton
        else {return}
        
        self.selectedIndex = sender.tag
    }
    ///функции нотификации
    @objc func goToMainView() {
        self.selectedIndex = 0
    }
    
    @objc func hideTabBar(sender: Notification) {
        let isHide = sender.userInfo?["isHide"] as! Bool //будем получать нотификацию по такому ключу
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else {return}
            if isHide {
                tabBarView.frame.origin.y = view.frame.height //скрываем ровно под низ экрана
            } else {
                tabBarView.frame.origin.y = view.frame.height - 100 //возвращаем на свое место
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TabBarView {
    
    private func createTabBarBtn(icon: UIImage, tag: Int, offsetX: Double, isBigBtn: Bool = false) -> UIButton {
        return {
            let btnSize = isBigBtn ? 60.0 : 25.0
            let yOffset = isBigBtn ? 0 : 15
            $0.frame.size = CGSize(width: btnSize, height: btnSize)
            $0.tag = tag
            $0.setBackgroundImage(icon, for: .normal)
            $0.frame.origin = CGPoint(x: .zero, y: yOffset)
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
