//
//  ViewController.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 03.03.2024.
//

import UIKit

protocol PasscodeViewProtocol: AnyObject {
    func passcode(state: PasscodeState)
    func enter(code: [Int])
}

class PasscodeView: UIViewController {
    
    var passcodePresenter: PasscodePresenterProtocol!
    
    private let buttons: [[Int]] = [[1,2,3], [4,5,6], [7,8,9], [0]]
    
    private lazy var passcodeTitle: UILabel = {
        .configure(view: $0) { label in
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textAlignment = .center
        }
    }(UILabel())
    
    private lazy var keyboardStack: UIStackView = {
        .configure(view: $0) { stack in
            stack.axis = .vertical
            stack.distribution = .equalSpacing
            stack.alignment = .center
        }
    }(UIStackView())
    
    private lazy var codeStack: UIStackView = {
        .configure(view: $0) { stack in
            stack.axis = .horizontal
            stack.distribution = .equalCentering
            stack.spacing = 20
        }
    }(UIStackView())
    
    private lazy var deleteBtn: UIButton = {
        .configure(view: $0) { btn in
            btn.heightAnchor.constraint(equalToConstant: 36).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 36).isActive = true
            btn.setBackgroundImage(.delete, for: .normal)
        }
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appMain
        
        [passcodeTitle, keyboardStack, codeStack, deleteBtn].forEach {
            view.addSubview($0)
        }
        
        //Создаем здесь клавиатуру
        buttons.forEach {
            let buttonsLine = setHorizontalNumberStack(range: $0)
            keyboardStack.addArrangedSubview(buttonsLine)
        }
        //Создаем вьюхи для пароля и добавляем в стек
        (11...14).forEach {
            let view = getPasswordView(tag: $0)
            codeStack.addArrangedSubview(view)
        }
        
        setLayout()
    }
    
}

extension PasscodeView: PasscodeViewProtocol {
    
    func passcode(state: PasscodeState) {
        passcodeTitle.text = state.getPasscodeLabel
    }
    
    func enter(code: [Int]) {
        
    }
}

extension PasscodeView {
    private func getHorizontalNumberStack() -> UIStackView {
        return {
            .configure(view: $0) { stack in
                stack.axis = .horizontal
                stack.spacing = 50
            }
        }(UIStackView())
    }
    ///Собираем стэк кнопок
    private func setHorizontalNumberStack(range: [Int]) -> UIStackView {
        let stack = getHorizontalNumberStack()
        
        range.forEach {
            let numberBtn = UIButton(primaryAction: nil)
            numberBtn.tag = $0 //записываем в тег значение элемента
            numberBtn.setTitle("\($0)", for: .normal)
            numberBtn.setTitleColor(.white, for: .normal)
            numberBtn.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .light)
            numberBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
            stack.addArrangedSubview(numberBtn)
        }
      return stack
    }
    
    private func getPasswordView(tag: Int) -> UIView {
        return {
            $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
            $0.layer.cornerRadius = 10
            $0.tag = tag
            $0.layer.borderColor = UIColor.white.cgColor
            
            return $0
        }(UIView())
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            passcodeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passcodeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passcodeTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            codeStack.topAnchor.constraint(equalTo: passcodeTitle.bottomAnchor, constant: 50),
            codeStack.widthAnchor.constraint(equalToConstant: 140),
            codeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            keyboardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            keyboardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            keyboardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyboardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            
            deleteBtn.rightAnchor.constraint(equalTo: keyboardStack.rightAnchor, constant: -20),
            deleteBtn.bottomAnchor.constraint(equalTo: keyboardStack.bottomAnchor, constant: -25)
        ])
    }
}
