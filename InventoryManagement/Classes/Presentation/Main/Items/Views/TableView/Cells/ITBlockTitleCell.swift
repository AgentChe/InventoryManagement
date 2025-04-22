//
//  ITBlockTitleCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit

final class ITBlockTitleCell: UITableViewCell {
    lazy var label = makeLabel()
    lazy var seeAllButton = makeSeeAllButton()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Quicksand.bold(size: 23.scale))
        .lineHeight(29.scale)
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
extension ITBlockTitleCell {
    func setup(element: ITBlockTitleElement) {
        let title: String = {
            switch element.block {
            case .demoItems:
                return "Items.DemoItems.Title".localized
            case .folders:
                return "Items.Folders.Title".localized
            case .lastAdded:
                return "Items.LastAdded.Title".localized
            case .allItems:
                return "Items.AllItems.Title".localized
            }
        }()
        label.attributedText = title.attributed(with: attrs)
        
        seeAllButton.isHidden = element.seeAllHidden
    }
}

// MARK: Private
private extension ITBlockTitleCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ITBlockTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            seeAllButton.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ITBlockTitleCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeeAllButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.SFPro.regular(size: 17.scale))
        
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle("Items.SeeAll".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
