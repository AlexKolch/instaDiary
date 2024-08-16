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
    var photoView: PhotoView! //объявили здесь, чтобы обнулять ссылку при уничтожении photoView контроллера (231 строчка)
    
    //Здесь создается шапка для topMenuView
    private let menuViewHeight = UIApplication.topSafeArea + 50
    
    private lazy var topMenuView: UIView = {
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
        $0.backgroundColor = .appMain
        return $0
    }(UIView())
    //
    
    lazy var backAction = UIAction { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
    }
    lazy var menuAction = UIAction { [weak self] _ in
        print("menu open")
    }
    
    ///созданный navigationHeader
    lazy var navigationHeader: NavigationHeader = {
        NavigationHeader(backAction: backAction, menuAction: menuAction, date: presenter.postItem.date ?? Date())
    }()
    
    lazy var collectionView: UICollectionView = {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 100, right: 0)
        $0.dataSource = self
        $0.delegate = self
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        $0.register(TagCollectionVCell.self, forCellWithReuseIdentifier: TagCollectionVCell.reuseId)
        $0.register(DetailsPhotoCell.self, forCellWithReuseIdentifier: DetailsPhotoCell.reuseId)
        $0.register(DetailDescriptionCell.self, forCellWithReuseIdentifier: DetailDescriptionCell.reuseId)
        $0.register(DetailsAddCommentCell.self, forCellWithReuseIdentifier: DetailsAddCommentCell.reuseId)
        $0.register(DetailsMapCell.self, forCellWithReuseIdentifier: DetailsMapCell.reuseId)
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionLayout()))
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
        view.addSubview(topMenuView)
        setupNavHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : true]) //отправили нотификацию
    }
    
    //MARK: - setup NavBar & Layout
    ///устанавливаем нужного типа navigationHeader
    private func setupNavHeader() {
        let navView = navigationHeader.getNavigationHeader(type: .detailsView)
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
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: nil)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 30)
       
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
            return presenter.postItem.photos?.count ?? 0
        case 1:
            return presenter.postItem.tags?.count ?? 0
        case 3:
            return presenter.postItem.comments?.count ?? 0
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = presenter.postItem
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsPhotoCell.reuseId, for: indexPath) as! DetailsPhotoCell
            cell.configure(postId: item.id ?? "", image: item.photos?[indexPath.item] ?? "photo")
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionVCell.reuseId, for: indexPath) as! TagCollectionVCell
            cell.configureCell(tag: item.tags?[indexPath.item] ?? "")
            return cell
        case 2,3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailDescriptionCell.reuseId, for: indexPath) as! DetailDescriptionCell
            
            if indexPath.section == 2 {
                cell.configureCell(date: nil, text: item.postDescription ?? "")
            } else {
                if let arrayComments = item.comments?.allObjects as? [Comment] {
                    cell.configureCell(date: arrayComments[indexPath.item].date, text: arrayComments[indexPath.item].comment ?? "")
                }
            }
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsAddCommentCell.reuseId, for: indexPath) as! DetailsAddCommentCell
            cell.completion = { textComment in
                print(textComment)
            }
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsMapCell.reuseId, for: indexPath) as! DetailsMapCell
//            cell.configureCell(coordinate: item.location) //локацию сделаем позже
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .gray
            return cell
        }
    }
}

extension DetailsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let itemPhoto = presenter.postItem.photos?[indexPath.item] //получили конкретную нажатую фотку
            let gettingPhoto: UIImage? = .getPhoto(for: presenter.postItem.id ?? "", photo: itemPhoto ?? "photo")
            photoView = Builder.createPhotoViewController(image: gettingPhoto) as? PhotoView
            
            if photoView != nil {
                addChild(photoView!)
                photoView?.view.frame = view.bounds
                view.addSubview(photoView!.view) //добавляем на вью вьюху дочернего контроллера
                
                ///Код который выполнится при нажатии кнопки closeButton
                photoView!.completion = { [weak self] in
                    self?.photoView!.view.removeFromSuperview()
                    self?.photoView?.removeFromParent()
                    self?.photoView = nil //обнуляем/уничтожаем ссылку на childVewController чтобы не создать утечку памяти
                }
            }
            
        }
    }
}

extension DetailsView: DetailsViewProtocol {
    
}
