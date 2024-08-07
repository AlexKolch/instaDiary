//
//  AddPostFieldCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 21.03.2024.
//

import UIKit

class AddPostFieldCell: UICollectionViewCell {
    static let reuseId = "AddPostFieldCell"
    
//    var tagCompletion: ( (String?) -> Void )?
    weak var delegate: AddPostViewDelegate?
    
    private lazy var tagField: UITextField = {
        $0.backgroundColor = .appBlack
        $0.attributedPlaceholder = NSAttributedString(string: "Добавить тег", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.4)])
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 1))
        $0.leftViewMode = .always
        $0.layer.cornerRadius = 24
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15)
        return $0
    }(UITextField(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 48), primaryAction: tagFieldAction))
    
    private lazy var tagFieldAction = UIAction { [weak self] _ in
        guard let self else { return }
//        self.tagCompletion?(tagField.text)
        delegate?.addTag(tag: tagField.text)
        self.tagField.text = ""
    }
    
    private lazy var placeholderLabel: UILabel = {
        $0.text = "Описание"
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .white.withAlphaComponent(0.4)
        return $0
    }(UILabel(frame: CGRect(x: 24, y: 19, width: 100, height: 20)))
    
    private lazy var textView: UITextView = {
        $0.addSubview(placeholderLabel)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 30
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15)
        $0.delegate = self
        return $0
    }(UITextView(frame: CGRect(x: 0, y: 68, width: bounds.width, height: 115)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tagField)
        addSubview(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddPostFieldCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    //Срабатывает в конце редактирования
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.addDescription(text: textView.text)
    }
}
