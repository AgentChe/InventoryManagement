//
//  CPTableGeneralCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import UIKit

final class CPTableGeneralCell: UITableViewCell {
    lazy var photoView = makePhotoView()
    lazy var collectionView = makeCollectionView()
    lazy var generalInputView = makeGeneralInputView()
    
    private lazy var generalInputSetuped = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CPTableGeneralCell {
    func setup(element: CPTableGeneralElement) {
        let photos = element.photos
        collectionView.setup(elements: photos)
        collectionView.isHidden = photos.isEmpty
        
        photoView.setup(selectedPhoto: element.selectedPhoto)
        
        if !generalInputSetuped {
            generalInputView.titleField.setup(title: element.title)
            generalInputView.countField.setup(count: element.count)
            generalInputView.priceField.setup(value: element.priceValue)
            generalInputView.priceField.setup(currency: element.priceCurrency)
            generalInputSetuped = true
        }
        generalInputView.priceField.setup(currency: element.priceCurrency)
    }
}

// MARK: Private
private extension CPTableGeneralCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CPTableGeneralCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -124.scale),
            photoView.heightAnchor.constraint(equalToConstant: 496.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -46.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            generalInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            generalInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            generalInputView.heightAnchor.constraint(equalToConstant: 154.scale),
            generalInputView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CPTableGeneralCell {
    func makePhotoView() -> CPPhotoView {
        let view = CPPhotoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCollectionView() -> CPPhotosCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60.scale, height: 60.scale)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12.scale
        layout.minimumInteritemSpacing = 0
        
        let view = CPPhotosCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeGeneralInputView() -> CPGeneralInputView {
        let view = CPGeneralInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
