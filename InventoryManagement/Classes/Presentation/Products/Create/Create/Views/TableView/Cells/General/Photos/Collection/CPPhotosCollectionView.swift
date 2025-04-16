//
//  CPPhotosCollectionView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import UIKit

final class CPPhotosCollectionView: UICollectionView {
    var didSelectPhoto: ((URL) -> Void)?
    var didDeletePhoto: ((URL) -> Void)?
    var didTapAdd: (() -> Void)?
    
    private lazy var elements = [CPPhotosCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CPPhotosCollectionView {
    func setup(elements: [CPPhotosCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension CPPhotosCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .photo(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CPPCollectionPhotoCell.self), for: indexPath) as! CPPCollectionPhotoCell
            cell.setup(element: element)
            return cell
        case .add:
            return dequeueReusableCell(withReuseIdentifier: String(describing: CPPCollectionAddCell.self), for: indexPath)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CPPhotosCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .photo(let element):
            let url = element.url
            element.selected ? didDeletePhoto?(url) : didSelectPhoto?(url)
        case .add:
            didTapAdd?()
        }
    }
}

// MARK: Private
private extension CPPhotosCollectionView {
    func initialize() {
        register(CPPCollectionPhotoCell.self, forCellWithReuseIdentifier: String(describing: CPPCollectionPhotoCell.self))
        register(CPPCollectionAddCell.self, forCellWithReuseIdentifier: String(describing: CPPCollectionAddCell.self))
        
        dataSource = self
        delegate = self
    }
}
