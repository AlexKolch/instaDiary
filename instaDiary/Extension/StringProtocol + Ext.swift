//
//  StringProtocol + Ext.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 07.03.2024.
//

import Foundation

extension StringProtocol {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
