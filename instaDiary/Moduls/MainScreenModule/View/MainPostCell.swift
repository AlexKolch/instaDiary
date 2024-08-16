//
//  MainPostCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 09.03.2024.
//

import UIKit

class MainPostCell: UICollectionViewCell {
    static let reuseId = "MainPostCell"
    private var tags: [String] = []
    
    private var tagCollectionView: UICollectionView!
    private var photoCountLabel = UILabel()
    private var commentCountLabel = UILabel()
    private var postDesciptionLabel = UILabel()
    
    lazy var postImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
       return $0
    }(UIImageView(frame: bounds))
    
    lazy var countLabelsStack: UIStackView = {
        .configure(view: $0) { stack in
            stack.axis = .horizontal
            stack.spacing = 20
            stack.addArrangedSubview(self.photoCountLabel)
            stack.addArrangedSubview(self.commentCountLabel)
            stack.addArrangedSubview(UIView()) //хак для нормального отображения
        }
    }(UIStackView())
    
    lazy var favoriteButton: UIButton = {
        $0.frame = CGRect(x: bounds.width - 60, y: 35, width: 25, height: 25)
        $0.setBackgroundImage(.heart, for: .normal)
        return $0
    }(UIButton(primaryAction: nil))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentViewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        tagCollectionView.removeFromSuperview()
        postDesciptionLabel.removeFromSuperview()
    }
    
    func configureCell(item: PostItem) {
        tags = item.tags ?? []
        
        let tagCollection: TagCollectionViewProtocol = TagCollectionView(dataSource: self)
        self.tagCollectionView = tagCollection.getCollectionView()
        
        postImage.image = UIImage.getMainImagePost(from: item.id ?? "", photos: item.photos) //Здесь устанавливается фотография поста
        
        photoCountLabel = getCellLabel(text: "\(String(describing: item.photos!.count)) фото")
        commentCountLabel = getCellLabel(text: "\(item.comments?.count ?? 0) комментарий")
        postDesciptionLabel = getCellLabel(text: item.postDescription ?? "")
        
        [countLabelsStack, tagCollectionView, postDesciptionLabel].forEach { addSubview($0) }
        
        setLayout()
    }
    
    private func getCellLabel(text: String) -> UILabel {
        return {
            .configure(view: $0) { label in
                label.numberOfLines = 0
                label.font = .systemFont(ofSize: 14)
                label.text = text
                label.textColor = .white
            }
        }(UILabel())
    }
    
    private func contentViewConfig() {
        [postImage, favoriteButton].forEach { addSubview($0) }
        layer.cornerRadius = 30
        clipsToBounds = true
        
        self.setViewGradient(frame: bounds, startPoint: CGPoint(x: 0.5, y: 1), endPoint: CGPoint(x: 0.5, y: 0.5), colors: [.black, .clear], location: [0.1])
    }
    
    fileprivate func setLayout() {
        NSLayoutConstraint.activate([
            
            countLabelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            countLabelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            countLabelsStack.bottomAnchor.constraint(equalTo: tagCollectionView.topAnchor, constant: -8),
            
            tagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 40),
            tagCollectionView.bottomAnchor.constraint(equalTo: postDesciptionLabel.topAnchor, constant: -10),
            
            postDesciptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            postDesciptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            postDesciptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}

extension MainPostCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnCell = TagCollectionVCell()
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionVCell.reuseId, for: indexPath) as? TagCollectionVCell {
            returnCell = cell
        }
        
        let tag = tags[indexPath.item]
        returnCell.configureCell(tag: tag)
        
        return returnCell
    }
    
}
