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
    
    func setViewGradient(frame: CGRect, startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], location: [NSNumber]) {
        let gradient = CAGradientLayer()
        
        gradient.frame = frame
        gradient.colors = colors.map({ $0.cgColor })
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = location
        
        self.layer.addSublayer(gradient)
    }
}
