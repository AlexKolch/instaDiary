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
    private var storageManager = StoreManager.shared
    private let coreManager = CoreManager.shared
    
    var photos: [UIImage]
    var tags: [String] = []
    var postDesription: String?
   
    required init(view: AddPostViewProtocol, photos: [UIImage]) {
        self.view = view
        self.photos = photos
    }
    
    func savePost() {
        let postId = UUID().uuidString
        //File Manager
        var photosData: [Data?] = []
        //конвертируем фотки в Data
        photos.forEach {
           let imageData = $0.jpegData(compressionQuality: 1.0)
            photosData.append(imageData)
        }
        
        let photosURLpath = storageManager.save(photos: photosData, postId: postId) //массив url адресов фоток из FileManager
       
        //Создаем объект внутри контекста - PostItem(context: ) Обязательно для сохр в CoreData
        let newPost: PostItem = {
            $0.id = postId
            $0.photos = photosURLpath //сохраняем в БД не бинарные данные, а url к фотографиям из FileManager!
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
