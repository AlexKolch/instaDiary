//
//  UIView + ext.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 03.03.2024.
//

import UIKit

extension UIView {
    ///disable AutoresizingMask
    static func configure<T: UIView>(view: T, completion: @escaping (T)->()) -> T {
        view.translatesAutoresizingMaskIntoConstraints = false
        completion(view)
        return view
    }
}
