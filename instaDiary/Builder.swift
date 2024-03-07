//
//  Builder.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 03.03.2024.
//

import UIKit

protocol BuilderProtocol {
    static func getPasscodeController(state: PasscodeState) -> UIViewController
}

class Builder: BuilderProtocol {
    static func getPasscodeController(state: PasscodeState) -> UIViewController {
        let passcodeView = PasscodeView()
        let keychainManager = KeychainManager()
        let presenter = PasscodePresenter(view: passcodeView, state: state, keychainManager: keychainManager)
        passcodeView.passcodePresenter = presenter
        return passcodeView
    }
}
