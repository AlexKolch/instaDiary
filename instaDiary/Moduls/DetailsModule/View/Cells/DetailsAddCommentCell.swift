//
//  DetailsAddCommentCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 19.03.2024.
//

import UIKit

class DetailsAddCommentCell: UICollectionViewCell {
    static let reuseId = "DetailsAddCommentCell"
    
    var completion: ((String) -> Void)? //передадим сюда значение из textField
    
    lazy var action = UIAction { [weak self] sender in
        let textField = sender.sender as! UITextField
        self?.completion?(textField.text ?? "")
        self?.endEditing(true)
    }
    
    lazy var textField: UITextField = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = bounds.height/2
        $0.placeholder = "Добавьте комментарий"
        $0.setLeftOffset()
        return $0
    }(UITextField(frame: bounds, primaryAction: action))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
