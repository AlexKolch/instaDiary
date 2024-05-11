//
//  MainScreenPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit

protocol MainScreenPresenterProtocol: AnyObject {
    init(view: MainScreenViewProtocol)
    var posts: [PostData]? {get set}
    func getPosts()
}

class MainScreenPresenter: MainScreenPresenterProtocol {
    
    private weak var view: MainScreenViewProtocol?
    private let coreManager = CoreManager.shared
    var posts: [PostData]? //посты
    
    required init(view: MainScreenViewProtocol) {
        self.view = view
        getPosts()
    }
    ///получение постов из CoreData
    func getPosts() {
        posts = coreManager.allPosts
        view?.showPost()
    }
    
}
