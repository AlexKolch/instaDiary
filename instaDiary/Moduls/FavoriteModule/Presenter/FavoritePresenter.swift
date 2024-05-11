//
//  FavoritePresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 16.03.2024.
//

import UIKit

protocol FavoritePresenterProtocol: AnyObject {
    init(view: FavoriteViewProtocol)
    var posts: [PostItem]? {get set}
    func getPosts()
}

class FavoritePresenter: FavoritePresenterProtocol {
    
    private weak var view: FavoriteViewProtocol?
    var posts: [PostItem]?
    
    required init(view: FavoriteViewProtocol) {
        self.view = view
        getPosts()
    }
    
    
    func getPosts() {
//        self.posts = PostItem.getPostItem()
        view?.showPosts()
    }
    
    
}
