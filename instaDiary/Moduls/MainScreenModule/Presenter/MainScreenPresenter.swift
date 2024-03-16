//
//  MainScreenPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit

protocol MainScreenPresenterProtocol: AnyObject {
    init(view: MainScreenViewProtocol)
    var posts: [PostDate]? {get set}
    func getPosts()
}

class MainScreenPresenter: MainScreenPresenterProtocol {
    
    private weak var view: MainScreenViewProtocol?
    var posts: [PostDate]?
    
    required init(view: MainScreenViewProtocol) {
        self.view = view
        getPosts()
    }
    
    func getPosts() {
        posts = PostDate.getMockData()
        view?.showPost()
    }
    
}
