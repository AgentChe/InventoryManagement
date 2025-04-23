//
//  FoldersCollectionView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class FoldersCollectionView: UICollectionView {
    private lazy var elements = [Folder]()
    
    private lazy var didSelectTrigger = PublishRelay<Folder>()
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension FoldersCollectionView {
    func setup(elements: [Folder]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<Folder> {
        didSelectTrigger.asSignal()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension FoldersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: FoldersCollectionCell.self), for: indexPath) as! FoldersCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension FoldersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        
        didScrollToBottomTrigger.accept(Void())
    }
}

// MARK: Private
private extension FoldersCollectionView {
    func initialize() {
        register(FoldersCollectionCell.self, forCellWithReuseIdentifier: String(describing: FoldersCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
