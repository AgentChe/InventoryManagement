//
//  CPPCollectionPhotoCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import UIKit
import Kingfisher

final class CPPCollectionPhotoCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    lazy var dimmedView = makeDimmedView()
    lazy var deleteView = makeDeleteView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension CPPCollectionPhotoCell {
    func setup(element: CPPCollectionPhotoElement) {
        imageView.kf.setImage(with: element.url)
        
        let borderColor = element.selected ? Appearance.main200 : Appearance.mono100
        contentView.layer.borderColor = borderColor.cgColor
        
        dimmedView.isHidden = !element.selected
        deleteView.isHidden = !element.selected
    }
}

// MARK: Private
private extension CPPCollectionPhotoCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.layer.borderWidth = 3.scale
        contentView.layer.cornerRadius = 20.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CPPCollectionPhotoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteView.widthAnchor.constraint(equalToConstant: 19.scale),
            deleteView.heightAnchor.constraint(equalToConstant: 22.scale),
            deleteView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CPPCollectionPhotoCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.backgroundColor = Appearance.mono200.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeDeleteView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "CreateProduct.Delete")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
