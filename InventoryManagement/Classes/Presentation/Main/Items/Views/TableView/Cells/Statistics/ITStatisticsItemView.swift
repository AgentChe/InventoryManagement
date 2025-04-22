//
//  ITStatisticsItemView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit

final class ITStatisticsItemView: UIView {
    lazy var valueLabel = makeLabel()
    lazy var titleLabel = makeLabel()
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.main200)
        .font(Fonts.Quicksand.bold(size: 32.scale))
        .lineHeight(40.scale)
        .textAlignment(.left)
    private lazy var currencyAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.bold(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.SFPro.regular(size: 17.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    
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
extension ITStatisticsItemView {
    func setup(productsCount: Int) {
        valueLabel.attributedText = String(productsCount).attributed(with: valueAttrs)
        titleLabel.attributedText = "Items.Statistics.ProductCount".localized.attributed(with: titleAttrs)
    }
    
    func setup(foldersCount: Int) {
        valueLabel.attributedText = String(foldersCount).attributed(with: valueAttrs)
        titleLabel.attributedText = "Items.Statistics.FoldersCount".localized.attributed(with: titleAttrs)
    }
    
    func setup(totalPrice: Price) {
        let formattedValue: String = {
            if totalPrice.value.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", totalPrice.value)
            } else {
                return String(totalPrice.value)
            }
        }()
        
        let value = NSMutableAttributedString()
        value.append(formattedValue.attributed(with: valueAttrs))
        value.append(totalPrice.currency.symbol.attributed(with: currencyAttrs))
        valueLabel.attributedText = value
        
        titleLabel.attributedText = "Items.Statistics.TotalPrice".localized.attributed(with: titleAttrs)
    }
    
    func setup(totalQTY: Int) {
        valueLabel.attributedText = String(totalQTY).attributed(with: valueAttrs)
        titleLabel.attributedText = "Items.Statistics.TotalQTY".localized.attributed(with: titleAttrs)
    }
}

// MARK: Private
private extension ITStatisticsItemView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ITStatisticsItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ITStatisticsItemView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
