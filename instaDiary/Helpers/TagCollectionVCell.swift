//
//  TagCollectionVCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 10.03.2024.
//

import UIKit

class TagCollectionVCell: UICollectionViewCell {
    static let reuseId = "TagCollectionVCell"
    
    private lazy var tagView: UIView = {
        .configure(view: $0) { view in
            view.backgroundColor = UIColor(white: 1, alpha: 0.12)
            view.layer.cornerRadius = 15
            view.addSubview(self.tagLabel)
        }
    }(UIView())
    
    private lazy var tagLabel: UILabel = {
        .configure(view: $0) { label in
            label.textColor = .white
            label.font = .systemFont(ofSize: 14)
        }
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tagView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(tag text: String) {
        self.tagLabel.text = text
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tagView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagView.topAnchor.constraint(equalTo: topAnchor),
            tagView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tagLabel.topAnchor.constraint(equalTo: tagView.topAnchor, constant: 5),
            tagLabel.bottomAnchor.constraint(equalTo: tagView.bottomAnchor, constant: -5),
            tagLabel.leadingAnchor.constraint(equalTo: tagView.leadingAnchor, constant: 20),
            tagLabel.trailingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: -20)
        ])
    }
}
