//
//  NSNotification.Name.ext.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 20.03.2024.
//

import Foundation

extension NSNotification.Name {
    ///из расширения для общего ключа 
    static let hideTabBar = NSNotification.Name("hideTabBar") //Чтобы не ошибиться с названием ключа нотификации
    static let goToMain = NSNotification.Name("goToMain")
}
