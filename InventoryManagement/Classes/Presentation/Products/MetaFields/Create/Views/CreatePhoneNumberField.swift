//
//  CreatePhoneNumberField.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit

final class CreatePhoneNumberField: CreateProductFieldView {
    lazy var nameField = makeNameField()
    lazy var valueField = makeValueField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func forceCheckEnable() {
        textEditing()
    }
    
    override func createField() -> any ProductMetaField {
        PhoneNumberField(
            name: nameField.text ?? "",
            phoneNumber: valueField.text
        )
    }
}

// MARK: UITextFieldDelegate
extension CreatePhoneNumberField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension CreatePhoneNumberField {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
    }
    
    @objc
    func textEditing() {
        let name = (nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        didChangeEnable?(!name.isEmpty)
    }
}

// MARK: Make constraints
private extension CreatePhoneNumberField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameField.topAnchor.constraint(equalTo: topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            valueField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            valueField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CreatePhoneNumberField {
    func makeNameField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.2))
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.delegate = self
        view.returnKeyType = .done
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "CreateMetaField.PhoneNumber.Name.Placeholder".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 20.scale, horizontal: 16.scale)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.2))
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.delegate = self
        view.keyboardType = .phonePad
        view.returnKeyType = .done
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "CreateMetaField.PhoneNumber.Value.Placeholder".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 20.scale, horizontal: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
