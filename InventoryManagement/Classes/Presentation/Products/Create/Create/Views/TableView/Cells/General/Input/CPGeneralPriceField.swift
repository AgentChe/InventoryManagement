//
//  CPGeneralPriceField.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import UIKit

final class CPGeneralPriceField: UIView {
    weak var vc: UIViewController?
    
    var changedPrice: ((Double) -> Void)?
    var changedCurrency: ((PriceCurrency) -> Void)?
    
    lazy var textField = makeTextField()
    lazy var currencyButton = makeCurrencyButton()
    lazy var separator = makeSeparator()
    
    private lazy var currencyAttrs = TextAttributes()
        .textColor(Appearance.main200)
        .font(Fonts.SFPro.regular(size: 15.scale))
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter
    }()
    
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
extension CPGeneralPriceField {
    func setup(value: Double?) {
        guard let value = value else {
            textField.text = nil
            return
        }
        
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            textField.text = String(Int(value))
        } else {
            textField.text = String(value)
        }
    }
    
    func setup(currency: PriceCurrency) {
        let symbol = currency.symbol
        currencyButton.setAttributedTitle(symbol.attributed(with: currencyAttrs), for: .normal)
    }
}

// MARK: Private
private extension CPGeneralPriceField {
    enum Currency {
        case dollar, euro
    }
    
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func priceValueEditing() {
        guard
            let text = textField.text,
            let value = formatter.number(from: text)?.doubleValue
        else { return }
        
        changedPrice?(value)
    }
    
    @objc
    func currencyTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let dollarAction = UIAlertAction(title: "CreateProduct.General.Input.Price.Dollar".localized, style: .default) { [weak self] action in
            self?.changedCurrency?(.dollar)
        }
        alert.addAction(dollarAction)
        
        let euroAction = UIAlertAction(title: "CreateProduct.General.Input.Price.Euro".localized, style: .default) { [weak self] action in
            self?.changedCurrency?(.euro)
        }
        alert.addAction(euroAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert.addAction(cancelAction)
        
        vc?.present(alert, animated: true)
    }
}

// MARK: Make constraints
private extension CPGeneralPriceField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currencyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            currencyButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CPGeneralPriceField {
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.2))
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = UIColor.clear
        view.keyboardType = .decimalPad
        view.returnKeyType = .done
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "CreateProduct.General.Input.Price.Placeholder".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 16.scale)
        view.addTarget(self, action: #selector(priceValueEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCurrencyButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.addTarget(self, action: #selector(currencyTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom202_202_202.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
