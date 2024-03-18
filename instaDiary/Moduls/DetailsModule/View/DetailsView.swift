//
//  DetailsView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 17.03.2024.
//

import UIKit

protocol DetailsViewProtocol: AnyObject {
    
}

class DetailsView: UIViewController {
    
    var presenter: DetailsPresenterProtocol!
    private let menuViewHeight = UIApplication.topSafeArea + 50
    
    private lazy var topMenuView: UIView = {
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
        return $0
    }(UIView())
    
    lazy var backAction = UIAction { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
    }
    lazy var menuAction = UIAction { [weak self] _ in
        print("menu open")
    }
    
    ///созданный navigationHeader
    lazy var navigationHeader: NavigationHeader = {
        NavigationHeader(backAction: backAction, menuAction: menuAction, date: presenter.postItem.date)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        setupNavHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.setHidesBackButton(true, animated: true) //тогда не будет работать жест смахивания страницы(можно добваить свой жест)
        navigationController?.navigationBar.isHidden = true
    }
    
    ///устанавливаем нужного типа navigationHeader
    private func setupNavHeader() {
        let navView = navigationHeader.getNavigationHeader(type: .back)
        navView.frame.origin.y = UIApplication.topSafeArea
        view.addSubview(navView)
    }
    
}

extension DetailsView: DetailsViewProtocol {
    
}
