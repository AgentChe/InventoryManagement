//
//  WhereMoveFoldersView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 24.04.2025.
//

import UIKit

final class WhereMoveFoldersView: UIView {
    lazy var collectionView = makeCollectionView()
    lazy var centerPreloader = makePreloader()
    lazy var bottomPreloader = makePreloader()
    
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
private extension WhereMoveFoldersView {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
    }
}

// MARK: Make constraints
private extension WhereMoveFoldersView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            centerPreloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerPreloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomPreloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomPreloader.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WhereMoveFoldersView {
    func makeCollectionView() -> FoldersCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 173.scale, height: 145.scale)
        layout.minimumInteritemSpacing = 10.scale
        layout.minimumLineSpacing = 10.scale
        layout.scrollDirection = .vertical
        
        let view = FoldersCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(value: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.showsVerticalScrollIndicator = false
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
