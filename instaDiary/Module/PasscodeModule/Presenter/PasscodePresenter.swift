//
//  PasscodePresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 03.03.2024.
//

import UIKit

protocol PasscodePresenterProtocol: AnyObject {
    var passcode: [Int] {get set}
    init(view: PasscodeViewProtocol, state: PasscodeState, keychainManager: KeychainManagerProtocol)
    func enterPasscode(number: Int)
    func removeLastItemToPasscode()
    func setNewPasscode()
    func checkPasscode()
    func clearPasscode(state: PasscodeState)
}

enum PasscodeState: String {
    case inputPasscode, wrongPasscode, setNewPasscode, repeatPasscode, codeNotMatch
    
    var getPasscodeLabel: String {
        switch self {
        case .inputPasscode:
            return "Введите код"
        case .wrongPasscode:
            return "Неверный код"
        case .setNewPasscode:
            return "Установить код"
        case .repeatPasscode:
            return "Повторить код"
        case .codeNotMatch:
            return "Коды не совпадают"
        }
    }
}

class PasscodePresenter: PasscodePresenterProtocol {
    
    var view: PasscodeViewProtocol
    var passcodeState: PasscodeState
    var keychainManager: KeychainManagerProtocol
    
    var passcode: [Int] = [] {
        didSet {
            if passcode.count == 4 {
                switch passcodeState {
                case .inputPasscode:
                    self.checkPasscode()
                case .setNewPasscode:
                    self.setNewPasscode()
                default:
                    break
                }
            }
        }
    }
    
    var templatePasscode: [Int]? //Временный набор пароля для его проверки
    
    required init(view: PasscodeViewProtocol, state: PasscodeState, keychainManager: KeychainManagerProtocol) {
        self.view = view
        self.passcodeState = state
        self.keychainManager = keychainManager
        
        view.passcode(state: passcodeState)
    }
    
    func enterPasscode(number: Int) {
        if passcode.count < 4 {
            passcode.append(number)
            view.enter(code: passcode)
        }
    }
    
    func removeLastItemToPasscode() {
        if !passcode.isEmpty {
            passcode.removeLast()
            view.enter(code: passcode)
        }
    }
    
    func setNewPasscode() {
        //проверка на повторный пароль
        if templatePasscode != nil {
            if passcode == templatePasscode {
                //пароли совпали -> переход в след модуль
                let stringPasscode = passcode.map { String($0) }.joined()
                keychainManager.save(key: KeychainManager.KeychainKeys.passcode.rawValue, value: stringPasscode)
                print("Saved passcode!")
            } else {
                view.passcode(state: .codeNotMatch)
            }
        } else {
            templatePasscode = passcode
            clearPasscode(state: .repeatPasscode)
        }
    }
    
    func checkPasscode() {
        let keychainPasscodeResult = keychainManager.load(key: KeychainManager.KeychainKeys.passcode.rawValue)
        switch keychainPasscodeResult {
        case .success(let code):
            if passcode == code.digits {
                print("success math code!")
            } else  {
                clearPasscode(state: .wrongPasscode)
            }
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
    func clearPasscode(state: PasscodeState) {
        passcode = []
        view.enter(code: [])
        view.passcode(state: state)
    }
    
    
}
