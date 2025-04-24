//
//  DemoProductView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit

final class DemoProductView: UIView {
    lazy var navigationView = makeNavigationView()
    lazy var tableView = makeTableView()
    
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
private extension DemoProductView {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
    }
}

// MARK: Make constraints
private extension DemoProductView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 94.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension DemoProductView {
    func makeNavigationView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            Appearance.mono200.withAlphaComponent(0.6).cgColor,
            Appearance.mono200.withAlphaComponent(0).cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> DemoProductTableView {
        let view = DemoProductTableView()
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
}
