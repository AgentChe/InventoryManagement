//
//  CPTDateFieldCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 26.04.2025.
//

import UIKit

final class CPTDateFieldCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var titleLabel = makeLabel()
    lazy var dateTextField = makeDateTextField()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done".localized, style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flex, done], animated: false)
        return toolbar
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale.current
        return formatter
    }()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.regular(size: 17.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    
    private var element: CPTDateFieldElement?
    
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
extension CPTDateFieldCell {
    func setup(element: CPTDateFieldElement) {
        self.element = element
        
        titleLabel.attributedText = element.name.attributed(with: titleAttrs)
        
        datePicker.date = element.date ?? Date()
        updateDateField()
    }
}

// MARK: Private
private extension CPTDateFieldCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func dateChanged(_ sender: UIDatePicker) {
        element?.date = sender.date
        
        updateDateField()
    }
    
    @objc
    func doneButtonTapped() {
        dateTextField.resignFirstResponder()
    }
    
    func updateDateField() {
        dateTextField.text = {
            guard let date = element?.date else { return nil }
            return dateFormatter.string(from: date)
        }()
    }
}

// MARK: Make constraints
private extension CPTDateFieldCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -128.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            dateTextField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dateTextField.widthAnchor.constraint(equalToConstant: 100.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CPTDateFieldCell {
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
    
    func makeDateTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = UIColor.clear
        view.defaultTextAttributes = attrs.dictionary
        view.inputView = datePicker
        view.textPadding = UIEdgeInsets(vertical: 20.scale)
        view.inputAccessoryView = toolBar
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
