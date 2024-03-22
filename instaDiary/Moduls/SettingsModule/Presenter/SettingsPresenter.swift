//
//  SettingsPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 22.03.2024.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    init(view: SettingsViewProtocol)
}

class SettingsPresenter: SettingsPresenterProtocol {
    
    private weak var view: SettingsViewProtocol?
    
    required init(view: SettingsViewProtocol) {
        self.view = view
    }
    
}
