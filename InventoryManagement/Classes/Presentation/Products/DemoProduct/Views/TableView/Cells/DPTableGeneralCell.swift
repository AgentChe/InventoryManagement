//
//  DPTableGeneralCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 24.04.2025.
//

import UIKit

final class DPTableGeneralCell: UITableViewCell {
    lazy var photoView = makeImageView()
    lazy var generalInputView = makeGeneralInputView()
    
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
extension DPTableGeneralCell {
    func setup(element: DPTableGeneralElement) {
        photoView.image = UIImage(named: element.photoName)
        
        generalInputView.titleField.setup(title: element.title)
        generalInputView.countField.setup(count: element.count)
        generalInputView.priceField.setup(value: element.priceValue)
        generalInputView.priceField.setup(currency: element.priceCurrency)
    }
}

// MARK: Private
private extension DPTableGeneralCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension DPTableGeneralCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -124.scale),
            photoView.heightAnchor.constraint(equalToConstant: 496.scale)
        ])
        
        NSLayoutConstraint.activate([
            generalInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            generalInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            generalInputView.heightAnchor.constraint(equalToConstant: 154.scale),
            generalInputView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DPTableGeneralCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeGeneralInputView() -> CPGeneralInputView {
        let view = CPGeneralInputView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
