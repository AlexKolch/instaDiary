//
//  UIImageView + ext.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 21.03.2024.
//

import UIKit

extension UIImageView {
    static func setImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 60, height: 60)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }
}
