//
//  TSFiltersCollectionCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 28.04.2025.
//

import UIKit

final class TSFiltersCollectionCell: UICollectionViewCell {
    var didTapDelete: (() -> Void)?
    
    lazy var label = makeLabel()
    lazy var deleteButton = makeDeleteButton()
    
    private static let titleAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SFPro.medium(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
    private lazy var attrs = Self.titleAttrs
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TSFiltersCollectionCell {
    static func width(element: String) -> CGFloat {
        let elementWidth = element.attributed(with: Self.titleAttrs).size().width
        return elementWidth + 51.scale
    }
    
    func setup(element: String) {
        label.attributedText = element.attributed(with: attrs)
    }
}

// MARK: Private
private extension TSFiltersCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = Appearance.main200
        contentView.layer.cornerRadius = 17.scale
        contentView.layer.masksToBounds = true
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func deleteTapped() {
        didTapDelete?()
    }
}

// MARK: Make constraints
private extension TSFiltersCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35.scale),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 13.scale),
            deleteButton.heightAnchor.constraint(equalToConstant: 14.scale),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            deleteButton.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TSFiltersCollectionCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeDeleteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Close.White"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
