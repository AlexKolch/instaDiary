//
//  TagCollectionView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 10.03.2024.
//

import UIKit

protocol TagCollectionViewProtocol: AnyObject {
    var dataSource: UICollectionViewDataSource {get set}
    var isEditing: Bool {get set}
    init(dataSource: UICollectionViewDataSource)
    func getCollectionView() -> UICollectionView
}

class TagCollectionView: TagCollectionViewProtocol {
    
    var isEditing: Bool = false
    
    var dataSource: UICollectionViewDataSource
    
    required init(dataSource: UICollectionViewDataSource) {
        self.dataSource = dataSource
    }
    
    func getCollectionView() -> UICollectionView{
        return {
            .configure(view: $0) { [weak self] collection in
                guard let self = self else {return}
                
                if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                    layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                }
                collection.alwaysBounceHorizontal = true
                collection.showsHorizontalScrollIndicator = false
                collection.backgroundColor = .clear
                collection.dataSource = self.dataSource
                collection.register(TagCollectionVCell.self, forCellWithReuseIdentifier: TagCollectionVCell.reuseId)
            }
        }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    }
  
}
