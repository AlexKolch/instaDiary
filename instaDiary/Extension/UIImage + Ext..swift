//
//  UIImage + Ext..swift
//  instaDiary
//
//  Created by Алексей Колыченков on 05.08.2024.
//

import UIKit

extension UIImage {
    
    static func getCoverImage(from folder: String, photos: [String]?) -> UIImage? {
        let photosData = StoreManager.shared.get(photos: photos ?? [], postId: folder)
        var coverImage = UIImage(systemName: "photo") //заглушка если нет фотографии
        
        if !photosData.isEmpty {
            coverImage = UIImage(data: photosData.first!) //Основная фотография поста
        }
        
        return coverImage
    }
}
