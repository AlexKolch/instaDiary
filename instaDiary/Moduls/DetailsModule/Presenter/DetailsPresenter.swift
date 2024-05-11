//
//  DetailsPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 17.03.2024.
//

import UIKit

protocol DetailsPresenterProtocol: AnyObject {
    init(view: DetailsViewProtocol, item: PostItem1)
    var postItem: PostItem1 {get}
}

class DetailsPresenter: DetailsPresenterProtocol {
    
    private weak var view: DetailsViewProtocol?
    var postItem: PostItem1
    
    required init(view: DetailsViewProtocol, item: PostItem1) {
        self.view = view
        self.postItem = item
    }
    
    
    
}
