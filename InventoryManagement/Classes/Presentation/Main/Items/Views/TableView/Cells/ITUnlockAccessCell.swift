//
//  ITUnlockAccessCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit

final class ITUnlockAccessCell: UITableViewCell {
    var didTap: (() -> Void)?
    
    lazy var backgroundImageView = makeBackgroundView()
    lazy var titleLabel = makeTitleLabel()
    lazy var button = makeButton()
    
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
private extension ITUnlockAccessCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func tapped() {
        didTap?()
    }
}

// MARK: Make constraints
private extension ITUnlockAccessCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 136.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16.scale),
            button.widthAnchor.constraint(equalToConstant: 111.scale),
            button.heightAnchor.constraint(equalToConstant: 34.scale),
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ITUnlockAccessCell {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "Items.UnlockAccess")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Quicksand.bold(size: 17.scale))
            .lineHeight(23.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 2
        view.attributedText = "Items.UnlockAccess.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.SFPro.regular(size: 15.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 17.scale
        view.setAttributedTitle("Items.UnlockAccess.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
