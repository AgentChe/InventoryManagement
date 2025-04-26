//
//  CPTDecimalNumberFieldCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 26.04.2025.
//

import UIKit

final class CPTDecimalNumberFieldCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var titleLabel = makeLabel()
    lazy var valueField = makeValueField()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.regular(size: 17.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private var element: CPTDecimalNumberFieldElement?
    
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
extension CPTDecimalNumberFieldCell {
    func setup(element: CPTDecimalNumberFieldElement) {
        self.element = element
        
        titleLabel.attributedText = element.name.attributed(with: titleAttrs)
        valueField.text = {
            guard let number = element.number else { return nil }
            return String(number)
        }()
    }
}

// MARK: UITextFieldDelegate
extension CPTDecimalNumberFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension CPTDecimalNumberFieldCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func textEditing() {
        let text = (valueField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        element?.number = formatter.number(from: text)?.doubleValue
    }
}

// MARK: Make constraints
private extension CPTDecimalNumberFieldCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            valueField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            valueField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            valueField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CPTDecimalNumberFieldCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.backgroundColor = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
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
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.returnKeyType = .done
        view.keyboardType = .decimalPad
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "CreateProduct.MetaFields.DN.Placeholder".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 20.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        container.addSubview(view)
        return view
    }
}
