//
//  UIImage + Ext..swift
//  instaDiary
//
//  Created by Алексей Колыченков on 05.08.2024.
//

import UIKit

extension UIImage {
    
    static func getMainImagePost(from folder: String, photos: [String]?) -> UIImage? {
        let photosData = StoreManager.shared.get(photos: photos ?? [], postId: folder)
        var coverImage = UIImage(systemName: "photo") //заглушка если нет фотографии
        
        if !photosData.isEmpty {
            coverImage = UIImage(data: photosData.first!) //Основная фотография поста
        }
        
        return coverImage
    }
    ///получаем фотографию из FileManager в UIImage
    static func getPhoto(for postId: String, photo: String) -> UIImage? {
        let photoData = StoreManager.shared.getPhotoData(postId: postId, photo: photo)
        guard let photoData else {return nil}
        return UIImage(data: photoData)
    }
}
