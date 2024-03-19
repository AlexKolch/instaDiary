//
//  DetailsPhotoCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 19.03.2024.
//

import UIKit

class DetailsPhotoCell: UICollectionViewCell {
    static let reuseId = "DetailsPhotoCell"
    
    lazy var imageCell: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView(frame: bounds))
    
    lazy var menuButton: UIButton = {
        $0.setBackgroundImage(.moreIcon, for: .normal)
        $0.frame = CGRect(x: imageCell.frame.width - 50, y: 30, width: 31, height: 6)
        return $0
    }(UIButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 30
        clipsToBounds = true
        addSubview(imageCell)
        imageCell.addSubview(menuButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: String) {
        imageCell.image = UIImage(named: image)
    }
}
