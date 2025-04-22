//
//  ITStatisticsCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit

final class ITStatisticsCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var productsCountView = makeItemView()
    lazy var foldersCountView = makeItemView()
    lazy var totalPriceView = makeItemView()
    lazy var totalQTYView = makeItemView()
    
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
extension ITStatisticsCell {
    func setup(element: Statistics) {
        productsCountView.setup(productsCount: element.productsCount)
        foldersCountView.setup(foldersCount: element.foldersCount)
        totalPriceView.setup(totalPrice: element.totalPrice)
        totalQTYView.setup(totalQTY: element.totalQTY)
    }
}

// MARK: Private
private extension ITStatisticsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ITStatisticsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 172.scale)
        ])
        
        NSLayoutConstraint.activate([
            productsCountView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            productsCountView.trailingAnchor.constraint(equalTo: container.centerXAnchor, constant: 8.scale),
            productsCountView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            productsCountView.bottomAnchor.constraint(equalTo: container.centerYAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            foldersCountView.leadingAnchor.constraint(equalTo: container.centerXAnchor, constant: 8.scale),
            foldersCountView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            foldersCountView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            foldersCountView.bottomAnchor.constraint(equalTo: container.centerYAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            totalPriceView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            totalPriceView.trailingAnchor.constraint(equalTo: container.centerXAnchor, constant: 8.scale),
            totalPriceView.topAnchor.constraint(equalTo: container.centerYAnchor, constant: 8.scale),
            totalPriceView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            totalQTYView.leadingAnchor.constraint(equalTo: container.centerXAnchor, constant: 8.scale),
            totalQTYView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            totalQTYView.topAnchor.constraint(equalTo: container.centerYAnchor, constant: 8.scale),
            totalQTYView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ITStatisticsCell {
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
    
    func makeItemView() -> ITStatisticsItemView {
        let view = ITStatisticsItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
