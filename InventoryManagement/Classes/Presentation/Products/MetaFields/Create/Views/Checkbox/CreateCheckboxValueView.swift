//
//  CreateCheckboxValueView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit

final class CreateCheckboxValueView: UIView {
    enum Value {
        case checked, unchecked
    }
    
    lazy var cursor = makeCursor()
    lazy var checkedButton = makeValueButton()
    lazy var uncheckedButton = makeValueButton()
    
    private lazy var cursorXConstraint = NSLayoutConstraint()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SFPro.semiBold(size: 13.scale))
    private lazy var normalAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.regular(size: 13.scale))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CreateCheckboxValueView {
    func setup(value: Value, animate: Bool) {
        updateCursor(value: value, animate: animate)
        updateButtons(value: value)
    }
}

// MARK: Private
private extension CreateCheckboxValueView {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 16.scale
        layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
    }
    
    func updateCursor(value: Value, animate: Bool) {
        cursorXConstraint.isActive = false
        switch value {
        case .checked:
            cursorXConstraint = cursor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.scale)
        case .unchecked:
            cursorXConstraint = cursor.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.scale)
        }
        cursorXConstraint.isActive = true
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
    }
    
    func updateButtons(value: Value) {
        let checkedAttrs = value == .checked ? selectedAttrs : normalAttrs
        checkedButton.setAttributedTitle("CreateMetaField.Checkbox.Value.Checked".localized.attributed(with: checkedAttrs), for: .normal)
        
        let uncheckedAttrs = value == .unchecked ? selectedAttrs : normalAttrs
        uncheckedButton.setAttributedTitle("CreateMetaField.Checkbox.Value.Unchecked".localized.attributed(with: uncheckedAttrs), for: .normal)
    }
}

// MARK: Make constraints
private extension CreateCheckboxValueView {
    func makeConstraints() {
        cursorXConstraint = cursor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.scale)
        NSLayoutConstraint.activate([
            cursorXConstraint,
            cursor.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale),
            cursor.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.scale),
            cursor.widthAnchor.constraint(equalToConstant: 179.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkedButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkedButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            checkedButton.topAnchor.constraint(equalTo: topAnchor),
            checkedButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            uncheckedButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            uncheckedButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            uncheckedButton.topAnchor.constraint(equalTo: topAnchor),
            uncheckedButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateCheckboxValueView {
    func makeCursor() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
