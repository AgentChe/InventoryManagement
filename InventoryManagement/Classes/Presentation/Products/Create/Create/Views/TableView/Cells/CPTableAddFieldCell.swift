//
//  CPTableAddFieldCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import UIKit

final class CPTableAddFieldCell: UITableViewCell {
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
private extension CPTableAddFieldCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CPTableAddFieldCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 17.scale),
            iconView.heightAnchor.constraint(equalToConstant: 18.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 27.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CPTableAddFieldCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CreateProduct.Add")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.SFPro.regular(size: 15.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "CreateProduct.AddFields.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
