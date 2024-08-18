//
//  CoreManager.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 11.05.2024.
//

import Foundation
import CoreData

class CoreManager {
    static let shared = CoreManager(); private init() { fetchPosts() }
    
    var allPosts: [PostData] = [] //данные постов
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "instaDiary")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
 
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    ///получение постов из CoreData
    func fetchPosts() {
        let request = PostData.fetchRequest() //request для получения постов
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] //сортировка по новым поcтам (вверху сегодняшняя дата)
        
        do {
            let posts = try persistentContainer.viewContext.fetch(request) //получаем данные из CoreData
            allPosts = posts //присваиваем полученные данные
        } catch {
            print(error.localizedDescription)
        }
    }
    
    ///получение favorite постов из CoreData
    func getFavoritePosts() -> [PostItem] {
        let bool = NSNumber(booleanLiteral: true) //bool не принимает предикат, поэтому переводим в number
        var allFavPost = [PostItem]()
        
        let favReq = PostItem.fetchRequest()
        favReq.predicate = NSPredicate(format: "isFavorite = %@", bool as CVarArg) //выборка достать только isFavorite = true посты
        
        do {
            let favPosts = try persistentContainer.viewContext.fetch(favReq)
            allFavPost = favPosts
        } catch {
            print(error.localizedDescription)
        }
        
        return allFavPost
    }
    
    ///Сохранение поста в  CoreData
    func save(post: PostItem) {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let startOfDay = calendar.startOfDay(for: currentDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1)
        
        let request = PostData.fetchRequest()
        //%@ - startOfDay и endOfDay даты.
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay as CVarArg, endOfDay! as CVarArg)
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            //Если посты за сегодня есть
            if !result.isEmpty, let parent = result.first {
                post.parent = parent
            } else {
                //если нет, создаем пост
                let parent = PostData(context: persistentContainer.viewContext)
                parent.id = UUID().uuidString
                parent.date = Date()
                post.parent = parent
            }
            
            saveContext()
            fetchPosts() //получаем обновленные данные
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
