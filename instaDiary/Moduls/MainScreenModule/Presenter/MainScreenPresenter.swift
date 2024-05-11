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
    var posts: [PostData]?
    
    required init(view: MainScreenViewProtocol) {
        self.view = view
        getPosts()
    }
    
    func getPosts() {
//        posts = PostDate1.getMockData()
        view?.showPost()
    }
    
}
