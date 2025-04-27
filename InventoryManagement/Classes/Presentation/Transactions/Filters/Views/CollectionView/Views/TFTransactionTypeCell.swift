//
//  TFTransactionTypeCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 27.04.2025.
//

import UIKit

final class TFTransactionTypeCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SFPro.medium(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.center)
    private lazy var normalAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.center)
    
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
extension TFTransactionTypeCell {
    func setup(element: TransactionsFiltersTypeElement) {
        let attrs = element.selected ? selectedAttrs : normalAttrs
        label.attributedText = element.type.attributed(with: attrs)
        
        container.backgroundColor = element.selected ? Appearance.main200 : Appearance.mono100
    }
}

// MARK: Private
private extension TFTransactionTypeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension TFTransactionTypeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TFTransactionTypeCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 17.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
