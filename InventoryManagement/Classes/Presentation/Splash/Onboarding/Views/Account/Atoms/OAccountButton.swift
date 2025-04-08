//
//  OAccountButton.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 08.04.2025.
//

import UIKit

final class OAccountButton: UIButton {
    enum AccountType {
        case personal, business
    }
    
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var iconView = makeIconView()
    lazy var nameLabel = makeNameLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    
    let type: AccountType
    
    init(type: AccountType) {
        self.type = type
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OAccountButton {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 24.scale
        layer.masksToBounds = true
    }
    
    func update() {
        layer.borderWidth = marked ? 3.scale : 0
        layer.borderColor = marked ? Appearance.main200.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension OAccountButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 148.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OAccountButton {
    func makeIconView() -> UIImageView {
        let imageName: String = {
            switch type {
            case .personal:
                return "Onboarding.Account.Personal"
            case .business:
                return "Onboarding.Account.Business"
            }
        }()
        
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: imageName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Quicksand.bold(size: 19.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        
        let title: String = {
            switch type {
            case .personal:
                return "Onboarding.Account.Personal.Title".localized
            case .business:
                return "Onboarding.Account.Business.Title".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.regular(size: 14.scale))
            .lineHeight(17.scale)
            .textAlignment(.left)
        
        let title: String = {
            switch type {
            case .personal:
                return "Onboarding.Account.Personal.SubTitle".localized
            case .business:
                return "Onboarding.Account.Business.SubTitle".localized
            }
        }()
        
        let view = UILabel()
        view.numberOfLines = 2
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
