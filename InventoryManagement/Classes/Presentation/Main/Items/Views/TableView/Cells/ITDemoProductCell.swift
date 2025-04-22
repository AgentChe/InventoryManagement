//
//  ITDemoProductCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit

final class ITDemoProductCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var textContainer = makeTextContainer()
    lazy var titleLabel = makeLabel()
    lazy var additionalInfoLabel = makeLabel()
    lazy var markView = makeMarkView()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Quicksand.bold(size: 21.scale))
        .lineHeight(26.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var additionalAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.SFPro.regular(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ITDemoProductCell {
    func setup(element: DemoProduct) {
        iconView.image = {
            switch element.product {
            case .stanleyCup:
                return UIImage(named: "Items.Demo.StanleyCup")
            case .vitaminC:
                return UIImage(named: "Items.Demo.VitaminC")
            }
        }()
        
        titleLabel.attributedText = element.title.attributed(with: titleAttrs)
        
        let additional = [element.countLocalized, element.barcode].joined(separator: "  ")
        additionalInfoLabel.attributedText = additional.attributed(with: additionalAttrs)
    }
}

// MARK: Private
private extension ITDemoProductCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ITDemoProductCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 98.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 66.scale),
            iconView.heightAnchor.constraint(equalToConstant: 66.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 86.scale),
            textContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            textContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: textContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            additionalInfoLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            additionalInfoLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),
            additionalInfoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            additionalInfoLabel.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            markView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            markView.centerYAnchor.constraint(equalTo: container.topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ITDemoProductCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        textContainer.addSubview(view)
        return view
    }
    
    func makeMarkView() -> PaddingLabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.regular(size: 12.scale))
            .lineHeight(14.scale)
        
        let view = PaddingLabel()
        view.attributedText = "Items.DemoItems.Mark".localized.attributed(with: attrs)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 11.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(vertical: 4.scale, horizontal: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
