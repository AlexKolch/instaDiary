//
//  AddPostPhotoCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 21.03.2024.
//

import UIKit

class AddPostPhotoCell: UICollectionViewCell {
    static let reuseId = "AddPostPhotoCell"
    
    private lazy var cellImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView(frame: bounds))
    
    private lazy var photoRemoveButton: UIButton = {
        $0.setBackgroundImage(.closeIcon, for: .normal)
        return $0
    }(UIButton(frame: CGRect(x: cellImage.frame.width - 30, y: 30, width: 15, height: 15), primaryAction: removeBtnAction))
    
    private lazy var removeBtnAction = UIAction { _ in
        print("remove")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 30
        clipsToBounds = true
        addSubview(cellImage)
        cellImage.addSubview(photoRemoveButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(image: UIImage) {
        cellImage.image = image
    }
}
