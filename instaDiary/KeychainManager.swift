//
//  KeychainManager.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 07.03.2024.
//

import Foundation
import KeychainAccess

protocol KeychainManagerProtocol: AnyObject {
    func save(key: String, value: String)
    func load(key: String) -> Result<String, Error>
}

class KeychainManager: KeychainManagerProtocol {
    
    private let keychain = Keychain(service: "PASSCODE")
    
    func save(key: String, value: String) {
        keychain[key] = value
    }
    
    func load(key: String) -> Result<String, Error> {
        do {
            let passcode = try keychain.getString(key) ?? ""
            return .success(passcode)
        } catch {
            return .failure(error)
        }
    }
    
    ///по этому ключу записываем наш пароль
    enum KeychainKeys: String {
        case passcode 
    }
}
