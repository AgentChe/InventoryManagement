//
//  CreateMetaFieldView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit

final class CreateMetaFieldView: UIView {
    lazy var grabberView = makeGrabberView()
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var createView = makeCreateView()
    lazy var saveButton = makeSaveButton()
    
    private let field: CreateMetaFieldViewController.Field
    
    init(field: CreateMetaFieldViewController.Field) {
        self.field = field
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CreateMetaFieldView {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
        
        createView.didChangeEnable = { [weak self] enable in
            self?.saveButton.alpha = enable ? 1 : 0.2
            self?.saveButton.isEnabled = enable
        }
        createView.forceCheckEnable()
    }
}

// MARK: Make constraints
private extension CreateMetaFieldView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            grabberView.widthAnchor.constraint(equalToConstant: 36.scale),
            grabberView.heightAnchor.constraint(equalToConstant: 5.scale),
            grabberView.centerXAnchor.constraint(equalTo: centerXAnchor),
            grabberView.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 17.scale),
            backButton.heightAnchor.constraint(equalToConstant: 22.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            createView.leadingAnchor.constraint(equalTo: leadingAnchor),
            createView.trailingAnchor.constraint(equalTo: trailingAnchor),
            createView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            createView.bottomAnchor.constraint(equalTo: saveButton.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 60.scale),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateMetaFieldView {
    func makeGrabberView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2.5.scale
        view.backgroundColor = Appearance.custom60_60_67.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CreateMetaField.Back"), for: .normal)
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
        
        let title: String = {
            switch field {
            case .smallTextBox:
                return "CreateMetaField.Title.STB".localized
            case .largeTextBox:
                return "CreateMetaField.Title.LTB".localized
            case .roundNumber:
                return "CreateMetaField.Title.RN".localized
            case .decimalNumber:
                return "CreateMetaField.Title.DN".localized
            case .checkbox:
                return "CreateMetaField.Title.Checkbox".localized
            case .date:
                return "CreateMetaField.Title.Date".localized
            case .phoneNumber:
                return "CreateMetaField.Title.PhoneNumber".localized
            case .webLink:
                return "CreateMetaField.Title.WebLink".localized
            case .email:
                return "CreateMetaField.Title.Email".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCreateView() -> CreateProductFieldView {
        let view: CreateProductFieldView = {
            switch field {
            case .smallTextBox:
                return CreateSTBField()
            case .largeTextBox:
                return CreateLTBField()
            case .roundNumber:
                return CreateRNField()
            case .decimalNumber:
                return CreateDNField()
            case .checkbox:
                return CreateCheckboxField()
            case .date:
                return CreateDateField()
            case .phoneNumber:
                return CreatePhoneNumberField()
            case .webLink:
                return CreateWebLinkField()
            case .email:
                return CreateEmailField()
            }
        }()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.regular(size: 17.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 20.scale
        view.setAttributedTitle("Save".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
