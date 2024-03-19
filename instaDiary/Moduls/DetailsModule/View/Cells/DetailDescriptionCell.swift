//
//  DetailDescriptionCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 19.03.2024.
//

import UIKit

class DetailDescriptionCell: UICollectionViewCell {
    static let reuseId = "DetailDescriptionCell"
    
    var dateLabel = UILabel()
    var descrLabel = UILabel()
    
    var labelsStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 7
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelsStack)
        backgroundColor = .appBlack
        layer.cornerRadius = 30
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            labelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.removeFromSuperview()
        descrLabel.removeFromSuperview()
    }
    
    func configureCell(date: Date?, text: String) {
        if date != nil {
            dateLabel = createCellLabel(text: date?.formattDate(formatType: .onlyDate) ?? "", weight: .bold)
            labelsStack.addArrangedSubview(dateLabel)
        }
        
        descrLabel = createCellLabel(text: text, weight: .regular)
        labelsStack.addArrangedSubview(descrLabel)
    }
    
    private func createCellLabel(text: String, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: weight)
        label.textColor = .white
        return label
    }
}
