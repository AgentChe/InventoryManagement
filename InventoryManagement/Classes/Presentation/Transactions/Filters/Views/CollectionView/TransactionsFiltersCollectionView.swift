//
//  TransactionsFiltersCollectionView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 27.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class TransactionsFiltersCollectionView: UICollectionView {
    private lazy var elements = [TransactionsFiltersCollectionElement]()
    
    private lazy var didTapSortTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TransactionsFiltersCollectionView {
    func setup(elements: [TransactionsFiltersCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapSort: Signal<Void> {
        didTapSortTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension TransactionsFiltersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .transactionTypesTitle:
            return dequeueReusableCell(withReuseIdentifier: String(describing: TFTransactionTypesTitleCell.self), for: indexPath)
        case .transactionType(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: TFTransactionTypeCell.self), for: indexPath) as! TFTransactionTypeCell
            cell.setup(element: element)
            return cell
        case .sort(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: TFSortCell.self), for: indexPath) as! TFSortCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TransactionsFiltersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .transactionType(let element):
            element.selected.toggle()
            reloadItems(at: [indexPath])
        case .sort:
            didTapSortTrigger.accept(Void())
        default:
            return 
        }
    }
}

// MARK: Private
private extension TransactionsFiltersCollectionView {
    func initialize() {
        register(TFTransactionTypesTitleCell.self, forCellWithReuseIdentifier: String(describing: TFTransactionTypesTitleCell.self))
        register(TFTransactionTypeCell.self, forCellWithReuseIdentifier: String(describing: TFTransactionTypeCell.self))
        register(TFSortCell.self, forCellWithReuseIdentifier: String(describing: TFSortCell.self))
        
        dataSource = self
        delegate = self
    }
}
