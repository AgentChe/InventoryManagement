//
//  OAccountView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 08.04.2025.
//

import UIKit

final class OAccountView: OSlideView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var personalButton = makeAccountButton(type: .personal)
    lazy var businessButton = makeAccountButton(type: .business)
    lazy var continueButton = makeContinueButton()
    
    private let onContinue: () -> Void
    
    init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        accountTypeTapped(sender: personalButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OAccountView {
    func initialize() {
        backgroundColor = Appearance.custom250_242_242
    }
    
    @objc
    func continueTapped() {
        onContinue()
    }
    
    @objc
    func accountTypeTapped(sender: UIButton) {
        guard let accountTypeButton = sender as? OAccountButton else { return }
        
        personalButton.marked = accountTypeButton.type == .personal
        businessButton.marked = accountTypeButton.type == .business
    }
}

// MARK: Make constraints
private extension OAccountView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 331.scale : 200.scale),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 212.scale : 128.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 94.scale : 35.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 22.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            personalButton.widthAnchor.constraint(equalToConstant: 173.scale),
            personalButton.heightAnchor.constraint(equalToConstant: 230.scale),
            personalButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            personalButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            businessButton.widthAnchor.constraint(equalToConstant: 173.scale),
            businessButton.heightAnchor.constraint(equalToConstant: 230.scale),
            businessButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            businessButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 60.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -29.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OAccountView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Account.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Quicksand.bold(size: 32.scale))
            .lineHeight(40.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Account.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Account.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAccountButton(type: OAccountButton.AccountType) -> OAccountButton {
        let view = OAccountButton(type: type)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(accountTypeTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.regular(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.main200
        view.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
