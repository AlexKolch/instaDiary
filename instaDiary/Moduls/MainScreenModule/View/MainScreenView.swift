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
    private var topInsets: CGFloat = 0.0
    private let menuViewHeight = UIApplication.topSafeArea + 70
    
    private lazy var topMenuView: UIView = {
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
        $0.backgroundColor = .appMain
        $0.addSubview(menuAppName)
        $0.addSubview(settingButton)
        return $0
    }(UIView())
    
    private lazy var menuAppName: UILabel = {
        $0.text = "instaDiary"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .white
        $0.frame = CGRect(x: 50, y: menuViewHeight - 40, width: view.bounds.width, height: 30)
        
        return $0
    }(UILabel())
    
    private lazy var settingButton: UIButton = {
        $0.frame = CGRect(x: view.bounds.width - 50, y: menuViewHeight - 35, width: 25, height: 25)
        $0.setBackgroundImage(UIImage(systemName: "gear"), for: .normal)
        $0.tintColor = .white
        return $0
    }(UIButton(primaryAction: settingButtonAction))
    
    private lazy var settingButtonAction = UIAction { _ in
        let settingVC = Builder.createSettingsViewController()
        self.present(settingVC, animated: true)
    }
    
   private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       let collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
       collection.backgroundColor = .appMain
       collection.dataSource = self
       collection.delegate = self
       collection.register(MainPostCell.self, forCellWithReuseIdentifier: MainPostCell.reuseId)
       collection.register(MainPostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainPostHeader.reuseId)
       collection.alwaysBounceVertical = true
       collection.contentInset.top = 80
       
       layout.itemSize = CGSize(width: view.frame.width - 60, height: view.frame.width - 60)
       layout.minimumLineSpacing = 30
       layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 40, right: 0)
       
       return collection
    }()
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
        view.addSubview(topMenuView)
        
        topInsets = collectionView.adjustedContentInset.top //отступ коллекции
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : false])
    }
    
    deinit{
        print("deinit MainVC")
    }
}

//MARK: - CollectionViewDelegate
extension MainScreenView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.posts?[section].items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPostCell.reuseId, for: indexPath) as? MainPostCell
        else { return UICollectionViewCell() }
        
        if let items = presenter.posts?[indexPath.section].items?.allObjects as? [PostItem] {
            
            let sortedDatePosts = items.sorted {
                $0.date ?? Date() > $1.date ?? Date() //сортировка отображаемых постов по дате
            }
            
            cell.configureCell(item: sortedDatePosts[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainPostHeader.reuseId, for: indexPath) as! MainPostHeader
        
        guard let dateString = presenter.posts?[indexPath.section].date?.getDateDiference() else { return header } //получаем дату в стринге

        header.setTitle(text: dateString)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width - 60, height: 40)
    }
    
//MARK: - ScrollDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//      print(scrollView.contentOffset.y + topInsets) //значение высоты начала сколл вью/ преобразовали в 0 значение для удобства благодаря topInsets
        let menuTopPosition = scrollView.contentOffset.y + topInsets + 59.0

        if menuTopPosition < 43.0, menuTopPosition > 0 {
            topMenuView.frame.origin.y = -menuTopPosition
            menuAppName.font = UIFont.systemFont(ofSize: 30 - menuTopPosition * 0.2,
                                                 weight: .bold)
        }
    }
}

extension MainScreenView: MainScreenViewProtocol {
    ///обновляем коллекцию
    func showPost() {
        collectionView.reloadData()
    }
    
}
