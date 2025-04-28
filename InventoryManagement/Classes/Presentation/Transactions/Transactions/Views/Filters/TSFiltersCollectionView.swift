//
//  TSFiltersCollectionView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 28.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class TSFiltersCollectionView: UICollectionView {
    private lazy var elements = [String]()
    
    private lazy var didTapDeleteFilterTypeTrigger = PublishRelay<String>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TSFiltersCollectionView {
    func setup(elements: [String]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapDeleteFilterType: Signal<String> {
        didTapDeleteFilterTypeTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension TSFiltersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: TSFiltersCollectionCell.self), for: indexPath) as! TSFiltersCollectionCell
        cell.setup(element: element)
        cell.didTapDelete = { [weak self] in
            self?.didTapDeleteFilterTypeTrigger.accept(element)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TSFiltersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: TSFiltersCollectionCell.width(element: elements[indexPath.row]),
            height: bounds.height
        )
    }
}

// MARK: Private
private extension TSFiltersCollectionView {
    func initialize() {
        register(TSFiltersCollectionCell.self, forCellWithReuseIdentifier: String(describing: TSFiltersCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
