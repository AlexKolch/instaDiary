//
//  StoreManager.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 03.08.2024.
//

import Foundation

protocol StoreManagerProtocol: AnyObject {
    ///Чтение/получение фоток
    func get(photos: [String], postId: String) -> [Data]
    ///Сохранение фоток в папку директории
    func save(photos: [Data?], postId: String) -> [String]
}

final class StoreManager: StoreManagerProtocol {
    
    static let shared = StoreManager(); private init(){}
  
    func get(photos: [String], postId: String) -> [Data] {
        var photosData = [Data]()
        var path = getPath().appending(path: postId) //зашли в папку поста
        
        photos.forEach {
            path.append(path: $0) //в этой папке берем каждый адрес/имя фотки
            if let photoData = try? Data(contentsOf: path) { //преобразуем в Data
                photosData.append(photoData)
            }
        }
        
        return photosData
    }
    
   
    func save(photos: [Data?], postId: String) -> [String] {
        var photoNames = [String]()
        
        photos.forEach { data in
            guard let data else { return }
            let photoName = savePhoto(postId: postId, photo: data)
            photoNames.append(photoName)
        }
        
        return photoNames
    }
    
    ///путь к директории file manager
    private func getPath() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    ///сохраняет фото и создает папку в директории если ее не было
    private func savePhoto(postId: String, photo: Data) -> String {
        let name = UUID().uuidString + ".jpeg"
        var path = getPath().appending(path: postId) //создание url/имя папки с постом
        
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true) //создание папки, если уже есть игнорируется
            path.append(path: name) //FolderName/asdf.jpeg создание имя файлу
            print(path)
            try photo.write(to: path) //записываем фотку в папку
        } catch {
            print("FileManager createDirectory error: \(error.localizedDescription)")
        }
        

        return name //Возвращает имя под которым сохранил фотку в FileManager, чтобы потом записать это имя в CoreData
    }
}
