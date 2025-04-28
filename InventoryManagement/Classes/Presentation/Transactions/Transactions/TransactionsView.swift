//
//  TransactionsView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 27.04.2025.
//

import UIKit

final class TransactionsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var filtersButton = makeFiltersButton()
    lazy var filtersCollectionView = makeFiltersCollectionView()
    lazy var tableView = makeTableView()
    lazy var centerPreloader = makePreloader()
    lazy var bottomPreloader = makePreloader()
    
    private lazy var tableTopConstraint = NSLayoutConstraint()
    
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
extension TransactionsView {
    func setup(hasSelectedFilters: Bool) {
        filtersButton.setup(hasSelectedFilters: hasSelectedFilters)
        filtersCollectionView.isHidden = !hasSelectedFilters
        
        tableTopConstraint.isActive = false
        tableTopConstraint = tableView.topAnchor.constraint(equalTo: hasSelectedFilters ? filtersCollectionView.bottomAnchor : titleLabel.bottomAnchor, constant: 2.scale)
        tableTopConstraint.isActive = true
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension TransactionsView {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
    }
}

// MARK: Make constraints
private extension TransactionsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 24.scale),
            filtersButton.heightAnchor.constraint(equalToConstant: 24.scale),
            filtersButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            filtersButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filtersCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filtersCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filtersCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.scale),
            filtersCollectionView.heightAnchor.constraint(equalToConstant: 34.scale)
        ])
        
        tableTopConstraint = tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            centerPreloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            centerPreloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomPreloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            bottomPreloader.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TransactionsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Quicksand.bold(size: 32.scale))
            .lineHeight(40.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Transactions.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFiltersButton() -> TransactionsFilterButton {
        let view = TransactionsFilterButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFiltersCollectionView() -> TSFiltersCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10.scale
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let view = TSFiltersCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> TransactionsItemsTableView {
        let view = TransactionsItemsTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
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
