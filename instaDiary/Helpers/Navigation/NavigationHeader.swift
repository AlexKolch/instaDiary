//
//  NavigationHeader.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 18.03.2024.
//

import UIKit

enum NavigationHeaderType {
    case back, close
}

class NavigationHeader {
    
    var backAction: UIAction?
    var closeAction: UIAction?
    var menuAction: UIAction?
    var date: Date
    
    ///вью на которую кладем кнопки
    private lazy var templateView: UIView = {
        $0.frame = CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width - 60, height: 44)
        $0.backgroundColor = .appMain
        $0.addSubview(dateStack)
        return $0
    }(UIView())
    
    lazy var dateLabel: UILabel = getHeaderLabel(text: date.formattDate(formatType: .onlyDate), size: 30, weight: .bold)
    lazy var yearLabel: UILabel = getHeaderLabel(text: date.formattDate(formatType: .onlyYear) + " год", size: 14, weight: .light)
    
    lazy var dateStack: UIStackView = {
        $0.axis = .vertical
        $0.addArrangedSubview(dateLabel)
        $0.addArrangedSubview(yearLabel)
        return $0
    }(UIStackView(frame: CGRect(x: 45, y: 0, width: 200, height: 44)))
    
    lazy var backButton: UIButton = getActionButton(origin: CGPoint(x: 0, y: 9), icon: .backIcon, action: backAction)
    lazy var closeButton: UIButton = getActionButton(origin: CGPoint(x: templateView.frame.width - 30, y: 0), icon: .closeIcon, action: closeAction)
    lazy var menuButton: UIButton = getActionButton(origin: CGPoint(x: templateView.frame.width - 30, y: 11), icon: .menuIcon, action: menuAction)
    
    init(backAction: UIAction? = nil, closeAction: UIAction? = nil, menuAction: UIAction? = nil, date: Date) {
        self.backAction = backAction
        self.closeAction = closeAction
        self.menuAction = menuAction
        self.date = date
    }
    ///получить NavigationHeader в зависимости от типа хиддера
    func getNavigationHeader(type: NavigationHeaderType) -> UIView {
        switch type {
        case .back:
            templateView.addSubview(backButton)
            templateView.addSubview(menuButton)
        case .close:
            templateView.addSubview(closeButton)
        }
        return templateView
    }
    
    private func getActionButton(origin: CGPoint, icon: UIImage, action: UIAction?) -> UIButton {
        let btn = UIButton(primaryAction: action)
        btn.frame.size = CGSize(width: 25, height: 25)
        btn.frame.origin = origin
        btn.setBackgroundImage(icon, for: .normal)
        return btn
    }
    
    private func getHeaderLabel(text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = .white
        return label
    }
}
