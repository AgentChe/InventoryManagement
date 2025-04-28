//
//  TransactionsItemsTableCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 28.04.2025.
//

import UIKit

final class TransactionsItemsTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var typeLabel = makeLabel()
    lazy var titleLabel = makeLabel()
    lazy var barcodeLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    lazy var unitsLabel = makeLabel()
    
    private lazy var typeAttrs = TextAttributes()
        .textColor(Appearance.main200)
        .font(Fonts.SFPro.regular(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Quicksand.bold(size: 21.scale))
        .lineHeight(26.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var barcodeAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.SFPro.regular(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var dateAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.SFPro.regular(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var unitsAttrs = TextAttributes()
        .textColor(Appearance.custom0_122_255)
        .font(Fonts.SFPro.regular(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
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
extension TransactionsItemsTableCell {
    func setup(item: TransactionItem) {
        typeLabel.attributedText = item.type.attributed(with: typeAttrs)
        titleLabel.attributedText = item.title.attributed(with: titleAttrs)
        barcodeLabel.attributedText = item.barcode.attributed(with: barcodeAttrs)
        dateLabel.attributedText = dateFormatter.string(from: item.date).attributed(with: dateAttrs)
        
        let unitLocalized = String.choosePluralForm(
            byNumber: item.count,
            one: "Unit.One".localized,
            two: "Unit.Two".localized,
            many: "Unit.Many".localized
        )
        unitsLabel.attributedText = String(format: "%i %@", item.count, unitLocalized).attributed(with: unitsAttrs)
    }
}

// MARK: Private
private extension TransactionsItemsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TransactionsItemsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 98.scale)
        ])
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            typeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -76.scale),
            typeLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -76.scale),
            titleLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            barcodeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            barcodeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -76.scale),
            barcodeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            dateLabel.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            unitsLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            unitsLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TransactionsItemsTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
