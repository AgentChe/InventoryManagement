//
//  CPTCheckboxFieldCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 26.04.2025.
//

import UIKit

final class CPTCheckboxFieldCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var titleLabel = makeLabel()
    lazy var checkedButton = makeCheckedButton()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.regular(size: 17.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    
    private var element: CPTCheckboxFieldElement?
    
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
extension CPTCheckboxFieldCell {
    func setup(element: CPTCheckboxFieldElement) {
        self.element = element
        
        titleLabel.attributedText = element.name.attributed(with: titleAttrs)
        
        updateIcon()
    }
}

// MARK: Private
private extension CPTCheckboxFieldCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func tapped() {
        element?.value?.toggle()
        
        updateIcon()
    }
    
    func updateIcon() {
        let iconName = element?.value == true ? "CreateProduct.Checkbox.E" : "CreateProduct.Checkbox.D"
        checkedButton.setImage(UIImage(named: iconName), for: .normal)
    }
}

// MARK: Make constraints
private extension CPTCheckboxFieldCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -48.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            checkedButton.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedButton.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            checkedButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CPTCheckboxFieldCell {
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
    
    func makeCheckedButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}
