//
//  MainScreenView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit

protocol MainScreenViewProtocol: AnyObject {
    func showPost()
}

class MainScreenView: UIViewController {
    
    var presenter: MainScreenPresenterProtocol!
    
   private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       let collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
       collection.backgroundColor = .appMain
       collection.dataSource = self
       collection.delegate = self
       collection.register(MainPostCell.self, forCellWithReuseIdentifier: MainPostCell.reuseId)
       collection.register(MainPostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainPostHeader.reuseId)
       collection.alwaysBounceVertical = true
       
       layout.itemSize = CGSize(width: view.frame.width - 60, height: view.frame.width - 60)
       layout.minimumLineSpacing = 30
       layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 40, right: 0)
       
       return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
    }
}

extension MainScreenView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.posts?[section].items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPostCell.reuseId, for: indexPath) as? MainPostCell
        else { return UICollectionViewCell() }
        
        cell.backgroundColor = .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainPostHeader.reuseId, for: indexPath) as! MainPostHeader
        
        guard let dateString = presenter.posts?[indexPath.section].date.getDateDiference() else { return header } //получаем дату в стринге

        header.setTitle(text: dateString)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width - 60, height: 40)
    }
}

extension MainScreenView: MainScreenViewProtocol {
    ///обновляем коллекцию
    func showPost() {
        collectionView.reloadData()
    }
    
}
