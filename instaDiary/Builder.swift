//
//  Builder.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 03.03.2024.
//

import UIKit

protocol BuilderProtocol {
    static func getPasscodeController() -> UIViewController
}

class Builder: BuilderProtocol {
    static func getPasscodeController() -> UIViewController {
        let passcodeView = PasscodeView()
        let presenter = PasscodePresenter(view: passcodeView, state: .inputPasscode)
        passcodeView.passcodePresenter = presenter
        return passcodeView
    }
}
