//
//  FavoriteCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 16.03.2024.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    static let reuseId = "FavoriteCell"
    
    var removeCompletionBlock: (() -> Void)?
    
   lazy var postImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
       return $0
    }(UIImageView(frame: bounds))
    
    lazy var removeFromFavoriteViewBtn: UIButton = {
        $0.frame = CGRect(x: bounds.width - 43, y: 21, width: 25, height: 25)
        $0.setBackgroundImage(.heartBlack, for: .normal)
       return $0
    }(UIButton(primaryAction: UIAction(handler: { [weak self] _ in
        self?.removeCompletionBlock?()
    })))
    
    lazy var dateView: UIView = {
        $0.frame = CGRect(x: 10, y: bounds.height - 47,
                          width: bounds.width - 20,
                          height: 27)
        $0.backgroundColor = UIColor(white: 1, alpha: 0.4)
        $0.layer.cornerRadius = 14
        $0.addSubview(dateLabel)
        return $0
    }(UIView())
    
    lazy var dateLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
        $0.frame = CGRect(x: 0, y: 0, width: bounds.width - 20, height: 27)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [postImage, removeFromFavoriteViewBtn, dateView].forEach {
            addSubview($0)
        }
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(item: PostItem) {
        postImage.image = .getPhoto(for: item.id ?? "", photo: item.photos?.first ?? "")
        dateLabel.text = item.date?.formattDate() //получили дату форматированную в текст
    }
}
