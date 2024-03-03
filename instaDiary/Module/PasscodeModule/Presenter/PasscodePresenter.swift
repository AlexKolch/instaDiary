//
//  PasscodePresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 03.03.2024.
//

import UIKit

protocol PasscodePresenterProtocol: AnyObject {
    var passcode: [Int] {get set}
    init(view: PasscodeViewProtocol, state: PasscodeState)
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
    
    var passcode: [Int] = []
    var view: PasscodeViewProtocol
    var passcodeState: PasscodeState
    
    required init(view: PasscodeViewProtocol, state: PasscodeState) {
        self.view = view
        self.passcodeState = state
        
        view.passcode(state: .inputPasscode)
    }
    
    
    func enterPasscode(number: Int) {
        
    }
    
    func removeLastItemToPasscode() {
        
    }
    
    func setNewPasscode() {
        
    }
    
    func checkPasscode() {
        
    }
    
    func clearPasscode(state: PasscodeState) {
        
    }
    
    
}
