//
//  UIAplication.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 10.03.2024.
//

import UIKit

extension UIApplication {
    ///Верхняя safe area
    static var topSafeArea: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets.top ?? .zero
    }
}
