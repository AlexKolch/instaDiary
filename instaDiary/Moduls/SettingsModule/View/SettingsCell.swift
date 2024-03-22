//
//  SettingsCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 22.03.2024.
//

import UIKit

class SettingsCell: UITableViewCell {
    static let reuseId = "SettingsCell"
    
    var completion: ( ()->() )? //через него будем взаимодействовать с контроллером
    
    private lazy var cellView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .appMain
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.addSubview(viewStack)
        return $0
    }(UIView())
    
    private lazy var viewStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.addArrangedSubview(titleLabel)
        return $0
    }(UIStackView())
    
    private lazy var nextBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 18).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 25).isActive = true
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .white
        return $0
    }(UIButton(primaryAction: nextBtnActiom))
    
    private lazy var nextBtnActiom = UIAction { [weak self] _ in
        self?.completion?()
    }
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var locationSwitch: UISwitch = {
        $0.onTintColor = .lightGray
        return $0
    }(UISwitch())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellView)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(for type: SettigItems) {
        //устанавливаем правую кнопку в зависимости от типа настроек
        switch type {
        case .password, .delete:
            viewStack.addArrangedSubview(nextBtn)
        case .location:
            viewStack.addArrangedSubview(locationSwitch)
        }
        
        titleLabel.text = type.rawValue
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            viewStack.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 15),
            viewStack.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -15),
            viewStack.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            viewStack.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -20)
        ])
    }
    
}
