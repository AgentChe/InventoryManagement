//
//  TabView.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case items, transactions, add, search, settings
    }
    
    lazy var itemsButton = makeItemButton(domain: "Main.Items")
    lazy var transactionsButton = makeItemButton(domain: "Main.Transactions")
    lazy var addButton = makeAddButton()
    lazy var searchButton = makeItemButton(domain: "Main.Search")
    lazy var settingsButton = makeItemButton(domain: "Main.Settings")
    
    var selectedTab = Tab.items {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        itemsButton.marked = selectedTab == .items
        transactionsButton.marked = selectedTab == .transactions
        searchButton.marked = selectedTab == .search
        settingsButton.marked = selectedTab == .settings
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            itemsButton.widthAnchor.constraint(equalToConstant: 78.scale),
            itemsButton.heightAnchor.constraint(equalToConstant: 40.scale),
            itemsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemsButton.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale)
        ])
        
        NSLayoutConstraint.activate([
            transactionsButton.widthAnchor.constraint(equalToConstant: 78.scale),
            transactionsButton.heightAnchor.constraint(equalToConstant: 40.scale),
            transactionsButton.leadingAnchor.constraint(equalTo: itemsButton.trailingAnchor),
            transactionsButton.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale)
        ])
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 48.scale),
            addButton.heightAnchor.constraint(equalToConstant: 48.scale),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 3.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.widthAnchor.constraint(equalToConstant: 78.scale),
            searchButton.heightAnchor.constraint(equalToConstant: 40.scale),
            searchButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor),
            searchButton.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 78.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 40.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeItemButton(domain: String) -> TabItemButton {
        let view = TabItemButton(domain: domain)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Main.Add"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
