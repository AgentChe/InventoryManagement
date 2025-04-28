//
//  TransactionsFilterButton.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 28.04.2025.
//

import UIKit

final class TransactionsFilterButton: TapAreaButton {
    lazy var circleView = makeCircleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TransactionsFilterButton {
    func setup(hasSelectedFilters: Bool) {
        circleView.isHidden = !hasSelectedFilters
    }
}

// MARK: Private
private extension TransactionsFilterButton {
    func initialize() {
        backgroundColor = UIColor.clear
        setImage(UIImage(named: "Transactions.Filters"), for: .normal)
        layer.masksToBounds = false
    }
}

// MARK: Make constraints
private extension TransactionsFilterButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 11.scale),
            circleView.heightAnchor.constraint(equalToConstant: 11.scale),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4.scale),
            circleView.topAnchor.constraint(equalTo: topAnchor, constant: -2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TransactionsFilterButton {
    func makeCircleView() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 5.5.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
