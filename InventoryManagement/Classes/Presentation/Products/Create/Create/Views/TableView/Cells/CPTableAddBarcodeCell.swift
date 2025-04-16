//
//  CPTableAddBarcodeCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import UIKit

final class CPTableAddBarcodeCell: UITableViewCell {
    lazy var backgroundContainer = makeBackgroundContainer()
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CPTableAddBarcodeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CPTableAddBarcodeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            backgroundContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            backgroundContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale),
            backgroundContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundContainer.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 21.scale),
            iconView.heightAnchor.constraint(equalToConstant: 20.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 29.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CPTableAddBarcodeCell {
    func makeBackgroundContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CreateProduct.AddBarcode")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "CreateProduct.AddBarcode.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
