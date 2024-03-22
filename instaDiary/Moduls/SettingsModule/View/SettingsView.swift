//
//  SettingsView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 22.03.2024.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    var tableView: UITableView {get set}
}

class SettingsView: UIViewController, SettingsViewProtocol {
    
    lazy var tableView: UITableView = {
        $0.backgroundColor = .appBlack
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
        return $0
    }(UITableView(frame: view.bounds, style: .insetGrouped))
    
    
    var presenter: SettingsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Настройки"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        view.backgroundColor = .appBlack
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .appMain
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
    deinit {
        print("deinit SettingsVC")
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettigItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath) as! SettingsCell
        
        let cellType = SettigItems.allCases[indexPath.row] //получили конкретный тип ячейки по индексу
        cell.configureCell(for: cellType)
        
        cell.completion = {
            if indexPath.row == 0 {
                let passcodeVC = Builder.getPasscodeController(state: .setNewPasscode, sceneDelegate: nil, wasSetting: true)
                self.present(passcodeVC, animated: true)
            }
        }
        
        return cell
    }
    
}
