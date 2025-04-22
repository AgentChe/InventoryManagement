//
//  ITLastAddedCollectionView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit

final class ITLastAddedCollectionView: UICollectionView {
    var didSelect: ((Product) -> Void)?
    var didTapMenu: ((Product) -> Void)?
    
    private lazy var elements = [Product]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ITLastAddedCollectionView {
    func setup(elements: [Product]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension ITLastAddedCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ITLastAddedCollectionCell.self), for: indexPath) as! ITLastAddedCollectionCell
        cell.setup(product: product)
        cell.didTapMenu = { [weak self] in
            self?.didTapMenu?(product)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ITLastAddedCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect?(elements[indexPath.row])
    }
}

// MARK: Private
private extension ITLastAddedCollectionView {
    func initialize() {
        register(ITLastAddedCollectionCell.self, forCellWithReuseIdentifier: String(describing: ITLastAddedCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
