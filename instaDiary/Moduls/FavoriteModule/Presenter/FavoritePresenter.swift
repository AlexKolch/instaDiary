//
//  FavoritePresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 16.03.2024.
//

import UIKit

protocol FavoritePresenterProtocol: AnyObject {
    init(view: FavoriteViewProtocol)
    var posts: [PostItem1]? {get set}
    func getPosts()
}

class FavoritePresenter: FavoritePresenterProtocol {
    
    private weak var view: FavoriteViewProtocol?
    var posts: [PostItem1]?
    
    required init(view: FavoriteViewProtocol) {
        self.view = view
        getPosts()
    }
    
    
    func getPosts() {
        self.posts = PostItem1.getPostItem()
        view?.showPosts()
    }
    
    
}
