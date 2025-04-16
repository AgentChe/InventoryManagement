//
//  CPGeneralInputView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import UIKit

final class CPGeneralInputView: UIView {
    lazy var titleField = makeTitleField()
    lazy var countField = makeCountField()
    lazy var priceField = makePriceField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CPGeneralInputView {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 20.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension CPGeneralInputView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleField.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            countField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            countField.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -8.scale),
            countField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            priceField.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 8.scale),
            priceField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            priceField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CPGeneralInputView {
    func makeTitleField() -> CPGeneralTitleField {
        let view = CPGeneralTitleField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCountField() -> CPGeneralCountField {
        let view = CPGeneralCountField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePriceField() -> CPGeneralPriceField {
        let view = CPGeneralPriceField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
