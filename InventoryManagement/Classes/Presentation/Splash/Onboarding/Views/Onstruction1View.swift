//
//  Onstruction1View.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 08.04.2025.
//

import UIKit

final class Onstruction1View: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var continueButton = makeContinueButton()
    
    private let onContinue: () -> Void
    
    init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension Onstruction1View {
    func initialize() {
        backgroundColor = Appearance.custom250_242_242
    }
    
    @objc
    func continueTapped() {
        onContinue()
    }
}

// MARK: Make constraints
private extension Onstruction1View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 410.scale : 250.scale),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 410.scale : 250.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 130.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale)
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
private extension Onstruction1View {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Instruction1")
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
        view.attributedText = "Onboarding.Instruction1.Title".localized.attributed(with: attrs)
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
        view.attributedText = "Onboarding.Instruction1.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
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
