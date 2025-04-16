//
//  CPPCollectionAddCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import UIKit

final class CPPCollectionAddCell: UICollectionViewCell {
    lazy var blurView = makeBlurView()
    lazy var iconView = makeIconView()
    
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
private extension CPPCollectionAddCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CPPCollectionAddCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CPPCollectionAddCell {
    func makeBlurView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 20.scale
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CreateProduct.Add")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
