//
//  SMFTableCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit

final class SMFTableCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
    
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
extension SMFTableCell {
    func setup(element: SMFTableElement) {
        iconView.image = UIImage(named: element.iconName)
        label.attributedText = element.title.attributed(with: attrs)
    }
}

// MARK: Private
private extension SMFTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SMFTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -19.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SMFTableCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension SMFTableElement {
    var iconName: String {
        switch self {
        case .smallTextBox:
            return "MetaFields.STB"
        case .largeTextBox:
            return "MetaFields.LTB"
        case .roundNumber:
            return "MetaFields.RN"
        case .decimalNumber:
            return "MetaFields.DN"
        case .checkbox:
            return "MetaFields.Checkbox"
        case .date:
            return "MetaFields.Date"
        case .phoneNumber:
            return "MetaFields.PhoneNumber"
        case .webLink:
            return "MetaFields.WebLink"
        case .email:
            return "MetaFields.Email"
        }
    }
    
    var title: String {
        switch self {
        case .smallTextBox:
            return "MetaFields.STB".localized
        case .largeTextBox:
            return "MetaFields.LTB".localized
        case .roundNumber:
            return "MetaFields.RN".localized
        case .decimalNumber:
            return "MetaFields.DN".localized
        case .checkbox:
            return "MetaFields.Checkbox".localized
        case .date:
            return "MetaFields.Date".localized
        case .phoneNumber:
            return "MetaFields.PhoneNumber".localized
        case .webLink:
            return "MetaFields.WebLink".localized
        case .email:
            return "MetaFields.Email".localized
        }
    }
}
