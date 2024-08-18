//
//  FavoriteView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit

protocol FavoriteViewProtocol: AnyObject {
    func showPosts()
}

class FavoriteView: UIViewController {
    
    var presenter: FavoritePresenterProtocol!
    
    lazy var collectionView: UICollectionView = {
        let itemSize = ((view.bounds.width - 60) / 2) - 15 //Размер квадратная ячейки
        
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 50, left: 30, bottom: 80, right: 30)
        
        $0.backgroundColor = .appMain
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.dataSource = self
        $0.delegate = self
        $0.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseId)
        
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout()))
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar() //Устанавливаем здесь, чтобы reloadData не затирала наши настройки навБара и навБар прорисовывался заново при каждой перезагрузки вью
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : false])
    }
    
    private func setupNavBar() {
        title = "Избранное"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .appMain
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
    }
}

//MARK: - DataSource & Delegate
extension FavoriteView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseId, for: indexPath) as! FavoriteCell
        
        if let postItem = presenter.posts?[indexPath.item] {
            cell.configureCell(item: postItem)
            
            cell.removeCompletionBlock = {
                postItem.toggle(isFavorite: postItem.isFavorite) //в этом блоке значение isFavorite меняется на противоположное
            }
        }
        
        return cell
    }
}

extension FavoriteView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = presenter.posts?[indexPath.item] else {return}
        
        let detailsView = Builder.createDetailsController(item: item)
        navigationController?.pushViewController(detailsView, animated: true)
    }
}

extension FavoriteView: FavoriteViewProtocol {
    func showPosts() {
        //reloadData
    }
}
