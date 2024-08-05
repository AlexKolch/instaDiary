//
//  AddPostView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 21.03.2024.
//

import UIKit

protocol AddPostViewProtocol: AnyObject {
    var delegate: CameraViewDelegate? {get set}
}

protocol AddPostViewDelegate: AnyObject {
    func addTag(tag: String?)
    func addDescription(text: String?)
}

class AddPostView: UIViewController, AddPostViewProtocol {
    
    var presenter: AddPostPresenterProtocol!
    weak var delegate: CameraViewDelegate?
    
    private let menuViewHeight = UIApplication.topSafeArea + 50
    
    private lazy var topMenuView: UIView = {
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
        $0.backgroundColor = .appMain
        return $0
    }(UIView())
    
    lazy var backAction = UIAction { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
    }
    
    lazy var navigationHeader: NavigationHeader = {
        NavigationHeader(backAction: backAction, date: Date())
    }()
    
    private lazy var collectionView: UICollectionView = {
        $0.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 100, right: 0)
        $0.backgroundColor = .none
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.register(AddPostPhotoCell.self, forCellWithReuseIdentifier: AddPostPhotoCell.reuseId)
        $0.register(AddPostTagCell.self, forCellWithReuseIdentifier: AddPostTagCell.reuseId)
        $0.register(AddPostFieldCell.self, forCellWithReuseIdentifier: AddPostFieldCell.reuseId)
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionLayout()))
    
    private lazy var saveButton: UIButton = {
        $0.backgroundColor = .appBlack
        $0.setTitle("Сохранить", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.gray, for: .highlighted)
        $0.layer.cornerRadius = 27.5
        return $0
    }(UIButton(frame: CGRect(x: 30, y: view.bounds.height - 98, width: view.bounds.width - 60, height: 55), primaryAction: saveBtnAction))
    
    private lazy var saveBtnAction = UIAction { [weak self] _ in
        self?.presenter.savePost()
        print("post saved")
    }
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        view.addSubview(collectionView)
        view.addSubview(topMenuView)
        view.addSubview(saveButton)
        getHeader()
    
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        ///Натификация на появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        ///Натификация на закрывание клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getHeader() {
        let header = navigationHeader.getNavigationHeader(type: .addPostView)
        header.frame.origin.y = UIApplication.topSafeArea
        view.addSubview(header)
    }
    @objc func endEditing() {
        view.endEditing(true)
    }
    @objc func keyboardChange(notify: Notification) {
        guard let keyboardValue = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return} //координаты клавы
        
        let keyboardViewFrame = view.convert(keyboardValue.cgRectValue, from: view.window) //сконвертировали NSValue в значение вьюхи
        
        if notify.name == UIResponder.keyboardWillChangeFrameNotification {
            collectionView.contentInset.bottom = keyboardViewFrame.height //если клава появляется отступ для коллекции равен высоте клавы
        } else {
            collectionView.contentInset.bottom = 100
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit AddPostView")
    }
}
//MARK: - Composition Layout
extension AddPostView {
    
   private func getCompositionLayout() -> UICollectionViewCompositionalLayout {
       UICollectionViewCompositionalLayout { section, _ in
           switch section {
           case 0:
               return self.createPhotoSectionLayout()
           case 1:
               return self.createTagSectionLayout()
           default:
               return self.createFormSectionLayout()
           }
       }
    }
    private func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(185), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 30, bottom: 25, trailing: 30)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    private func createTagSectionLayout() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(110), heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [.init(layoutSize: groupSize)])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(10), bottom: nil)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    private func createFormSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(185))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        return section
    }
}
//MARK: - DataSource
extension AddPostView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return presenter.photos.count
        case 1:
            return presenter.tags.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostPhotoCell.reuseId, for: indexPath) as! AddPostPhotoCell
            let image = presenter.photos[indexPath.item]
            cell.configureCell(image: image)
            
            cell.completion = { [weak self] in
                self?.delegate?.deleteImage(for: indexPath.row)
                self?.presenter.photos.remove(at: indexPath.row)
                self?.collectionView.deleteItems(at: [indexPath])
            }
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostTagCell.reuseId, for: indexPath) as! AddPostTagCell
            let tag = presenter.tags[indexPath.item]
            
            cell.setTag(text: tag, index: indexPath.item)
            cell.deletedCompletion = { [weak self] tag in
                self?.presenter.tags.remove(at: tag) //удаляем переданный тег по индексу в массиве
                collectionView.reloadSections(.init(integer: 1))
            }
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPostFieldCell.reuseId, for: indexPath) as! AddPostFieldCell
           
//            cell.tagCompletion = { [weak self] tag in
//                guard let self else {return}
//                guard let tag else {return}
//                
//                self.presenter.tags.append(tag)
//                collectionView.reloadSections(.init(integer: 1))
//            }
            cell.delegate = self
            return cell
        }
    }
}

extension AddPostView: AddPostViewDelegate {
    
    func addTag(tag: String?) {
        guard let tag else {return}
        self.presenter.tags.append(tag)
        collectionView.reloadSections(.init(integer: 1))
    }
    
    func addDescription(text: String?) {
        presenter.postDesription = text
//        print("Ввели описание поста: \(text)")
    }
    
}
