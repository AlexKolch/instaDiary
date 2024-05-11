//
//  DetailsPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 17.03.2024.
//

import UIKit

protocol DetailsPresenterProtocol: AnyObject {
    init(view: DetailsViewProtocol, item: PostItem)
    var postItem: PostItem {get}
}

class DetailsPresenter: DetailsPresenterProtocol {
    
    private weak var view: DetailsViewProtocol?
    var postItem: PostItem
    
    required init(view: DetailsViewProtocol, item: PostItem) {
        self.view = view
        self.postItem = item
    }
    
    
    
}
