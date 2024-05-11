//
//  AddPostPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 21.03.2024.
//

import UIKit

protocol AddPostPresenterProtocol: AnyObject {
    init(view: AddPostViewProtocol, photos: [UIImage])
    var photos: [UIImage] { get set }
    var tags: [String] { get set }
    var postDesription: String? { get set }
    func savePost()
}

class AddPostPresenter: AddPostPresenterProtocol {
    
    private weak var view: AddPostViewProtocol?
    private let coreManager = CoreManager.shared
    
    var photos: [UIImage]
    var tags: [String] = []
    var postDesription: String?
    
    required init(view: AddPostViewProtocol, photos: [UIImage]) {
        self.view = view
        self.photos = photos
    }
    
    func savePost() {
        //File Manager
        let postId = UUID().uuidString
        //Создаем объект внутри контекста - PostItem(context: ) Обязательно для сохр в CoreData
        let newPost: PostItem = {
            $0.id = postId
            $0.photos = ["img1", "img2"]
            $0.comments = []
            $0.tags = tags
            $0.date = Date()
            $0.isFavorite = false
            $0.postDescription = postDesription
            return $0
        }(PostItem(context: coreManager.persistentContainer.viewContext))
       
        coreManager.save(post: newPost)
    }
 
}
