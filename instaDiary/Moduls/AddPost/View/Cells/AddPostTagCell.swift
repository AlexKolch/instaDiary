//
//  AddPostTagCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 21.03.2024.
//

import UIKit

class AddPostTagCell: UICollectionViewCell {
    static let reuseId = "AddPostTagCell"
    
    private var tagIndex = 0
    var deletedCompletion: ( (Int) -> Void )? //передаем сюда индекс удаленного тега
    ///вьюха на всю ячейку
    private lazy var tagView: UIView = {
        .configure(view: $0) { view in
            view.backgroundColor = UIColor(white: 1, alpha: 0.2)
            view.layer.cornerRadius = 14
            view.addSubview(self.tagStack)
        }
    }(UIView())
    
    private let tagLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    
    private lazy var removeBtn: UIButton = {
        .configure(view: $0) { btn in
            btn.setBackgroundImage(.closeIcon, for: .normal)
            btn.heightAnchor.constraint(equalToConstant: 15).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 15).isActive = true
        }
    }(UIButton(primaryAction: removeAction))
    
    private lazy var removeAction = UIAction { [weak self] _ in
        guard let self else {return}
        print(self.tagIndex) //по этому индексу удаляем тег
        deletedCompletion?(tagIndex) //передаем тег выше в AddPostView
    }
    
    
    private lazy var tagStack: UIStackView = {
        .configure(view: $0) { stack in
            stack.axis = .horizontal
            stack.spacing = 20
            stack.addArrangedSubview(self.tagLabel)
            stack.addArrangedSubview(self.removeBtn)
        }
    }(UIStackView())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tagView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTag(text: String, index: Int) {
        self.tagLabel.text = text
        self.tagIndex = index
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tagView.topAnchor.constraint(equalTo: topAnchor),
            tagView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tagStack.topAnchor.constraint(equalTo: tagView.topAnchor, constant: 7),
            tagStack.leadingAnchor.constraint(equalTo: tagView.leadingAnchor, constant: 20),
            tagStack.trailingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: -20),
            tagStack.bottomAnchor.constraint(equalTo: tagView.bottomAnchor, constant: -7)
        ])
    }
}
