//
//  PostItem.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 09.03.2024.
//

import Foundation
import CoreLocation

//class PostDate1: Identifiable {
//    let id = UUID().uuidString
//    let items: [PostItem]
//    let date: Date
//    
//    init(items: [PostItem], date: Date) {
//        self.items = items
//        self.date = date
//    }
    
//    static func getMockData() -> [PostDate] {
//        //Секции постов разделены по дням
//        [   //1 секция
//            PostDate(items: [
//                PostItem(photos: ["img1", "img2"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", date: Date()),
//                PostItem(photos: ["img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam", date: Date()),
//                PostItem(photos: ["img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam", date: Date())
//            ], date: Date()),
//            //2 секция
//            PostDate(items: [
//                PostItem(photos: ["img2"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "labore et dolore magna aliqua. Ut enim ad minim veniam", date: Date()),
//                PostItem(photos: ["img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "Ut enim ad minim veniam tempor incididunt ut labore et dolore magna aliqua", date: Date()),
//            ], date: Date().addingTimeInterval(-86400)), //86400 - Секунд в сутках/вчерашняя дата
//            //3 секция
//            PostDate(items: [
//                PostItem(photos: ["img2", "img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "labore et dolore magna aliqua", date: Date()),
//                PostItem(photos: ["img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "labore et veniam tempor incididunt ut labore et dolore magna aliqua dolore magna aliqua", date: Date()),
//            ], date: Date().addingTimeInterval(-172800))
//        ]
//    }
//}

//class PostItem1: Identifiable {
//    let id = UUID().uuidString
//    let photos: [String]
//    let comments: [Comment1]?
//    let tags: [String]?
//    let postDescription: String?
//    let isFavorite: Bool
//    let date: Date
//    let location: CLLocationCoordinate2D?
//    
//    init(photos: [String], comments: [Comment1]?, tags: [String]?, description: String?, isFavorite: Bool = false, date: Date, location: CLLocationCoordinate2D? = nil) {
//        self.photos = photos
//        self.comments = comments
//        self.tags = tags
//        self.postDescription = description
//        self.isFavorite = isFavorite
//        self.date = date
//        self.location = location
//    }
    
//    static func getPostItem() -> [PostItem] {
//        [
//            PostItem(photos: ["img1", "img2"], comments: [Comment(date: Date(), comment: "jbdjasj SDFSD bdhbashbd hab"), Comment(date: Date(), comment: "jbdjasj  hab"), Comment(date: Date(), comment: "jbdjasj bdhbashbd hab"), Comment(date: Date(), comment: "jbdSFEFDS SD FSD SFDjasj bdhbashbd hab")], tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", isFavorite: true, date: Date(), location: CLLocationCoordinate2D(latitude: 40.728, longitude: -74)),
//            
//            PostItem(photos: ["img2", "img3"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", isFavorite: true, date: Date()),
//            
//            PostItem(photos: ["img3", "img1"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", isFavorite: true, date: Date()),
//            
//            PostItem(photos: ["img1", "img3"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", isFavorite: true, date: Date().addingTimeInterval(-86400)),
//            
//            PostItem(photos: ["img2", "img3"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", isFavorite: true, date: Date().addingTimeInterval(-86400)),
//            
//            PostItem(photos: ["img3", "img1"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", isFavorite: true, date: Date().addingTimeInterval(-86400)),
//            
//            PostItem(photos: ["img2", "img1"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", isFavorite: true, date: Date().addingTimeInterval(-172800)),
//            
//            PostItem(photos: ["img3", "img1"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit", isFavorite: true, date: Date().addingTimeInterval(-172800)),
//            
//        ]
//    }
//}

class Comment1: Identifiable {
    let id = UUID().uuidString
    let date: Date
    let comment: String
    
    init(date: Date, comment: String) {
        self.date = date
        self.comment = comment
    }
}
