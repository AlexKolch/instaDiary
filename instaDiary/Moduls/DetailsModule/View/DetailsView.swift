//
//  DetailsView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 17.03.2024.
//

import UIKit

protocol DetailsViewProtocol: AnyObject {
    
}

class DetailsView: UIViewController {
    
    var presenter: DetailsPresenterProtocol!
    private let menuViewHeight = UIApplication.topSafeArea + 50
    
    private lazy var topMenuView: UIView = {
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
        return $0
    }(UIView())
    
    lazy var backAction = UIAction { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
    }
    lazy var menuAction = UIAction { [weak self] _ in
        print("menu open")
    }
    
    ///созданный navigationHeader
    lazy var navigationHeader: NavigationHeader = {
        NavigationHeader(backAction: backAction, menuAction: menuAction, date: presenter.postItem.date)
    }()
    
    lazy var collectionView: UICollectionView = {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 100, right: 0)
        $0.dataSource = self
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        $0.register(TagCollectionVCell.self, forCellWithReuseIdentifier: TagCollectionVCell.reuseId)
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionLayout()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
        setupNavHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.setHidesBackButton(true, animated: true) //тогда не будет работать жест смахивания страницы(можно добваить свой жест)
        navigationController?.navigationBar.isHidden = true
    }
    
    ///устанавливаем нужного типа navigationHeader
    private func setupNavHeader() {
        let navView = navigationHeader.getNavigationHeader(type: .back)
        navView.frame.origin.y = UIApplication.topSafeArea
        view.addSubview(navView)
    }
    
    private func getCompositionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch section {
            case 0:
                return self?.createPhotoSectionLayout()
            case 1:
                return self?.createTagSectionLayout()
            case 2,3:
                return self?.createDesriptionSectionLayout()
            case 4:
                return self?.createCommentFieldSectionLayout()
            case 5:
                return self?.createMapSectionLayout()
            default:
                return self?.createPhotoSectionLayout()
            }
        }
    }
    
    private func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30)
        return section
    }
    private func createTagSectionLayout() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(110), heightDimension: .estimated(30))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [.init(layoutSize: groupSize)])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    private func createDesriptionSectionLayout() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [.init(layoutSize: groupSize)])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(10))
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30)
       
        return section
    }
    private func createCommentFieldSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 30, bottom: 60, trailing: 30)
        return section
    }
    private func createMapSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 60, trailing: 30)
        return section
    }
}

extension DetailsView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return presenter.postItem.photos.count
        case 1:
            return presenter.postItem.tags?.count ?? 0
        case 2, 4, 5:
            return 1
        case 3:
            return presenter.postItem.comments?.count ?? 0
        default:
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = presenter.postItem
        
        switch indexPath.section {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionVCell.reuseId, for: indexPath) as! TagCollectionVCell
            cell.configureCell(tag: item.tags?[indexPath.item] ?? "")
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .gray
            return cell
        }
        
        
    }
    
    
}

extension DetailsView: DetailsViewProtocol {
    
}
