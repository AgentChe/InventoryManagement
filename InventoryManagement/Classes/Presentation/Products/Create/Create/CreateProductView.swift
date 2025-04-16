//
//  CreateProductView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 11.04.2025.
//

import UIKit

final class CreateProductView: UIView {
    lazy var tableView = makeTableView()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CreateProductView {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
    }
}

// MARK: Make constraints
private extension CreateProductView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateProductView {
    func makeTableView() -> CreateProductTableView {
        let view = CreateProductTableView()
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(b: 62.scale)
        view.setContentOffset(CGPoint.zero, animated: false)
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = Appearance.main200
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
