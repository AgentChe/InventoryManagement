//
//  ITFoldersCollectionView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit

final class ITFoldersCollectionView: UICollectionView {
    var didSelect: ((Folder) -> Void)?
    var didTapAddNew: (() -> Void)?
    
    private lazy var elements = [ITFoldersCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ITFoldersCollectionView {
    func setup(folders: [Folder]) {
        elements = folders.map { ITFoldersCollectionElement.folder($0) } + [.addNew]
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension ITFoldersCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .folder(let folder):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ITFoldersCollectionCell.self), for: indexPath) as! ITFoldersCollectionCell
            cell.setup(folder: folder)
            return cell
        case .addNew:
            return dequeueReusableCell(withReuseIdentifier: String(describing: ITFoldersCollectionAddCell.self), for: indexPath)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ITFoldersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .folder(let folder):
            didSelect?(folder)
        case .addNew:
            didTapAddNew?()
        }
    }
}

// MARK: Private
private extension ITFoldersCollectionView {
    func initialize() {
        register(ITFoldersCollectionCell.self, forCellWithReuseIdentifier: String(describing: ITFoldersCollectionCell.self))
        register(ITFoldersCollectionAddCell.self, forCellWithReuseIdentifier: String(describing: ITFoldersCollectionAddCell.self))
        
        dataSource = self
        delegate = self
    }
}
