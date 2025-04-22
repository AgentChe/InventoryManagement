//
//  ITLastAddedCollectionCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit
import Kingfisher

final class ITLastAddedCollectionCell: UICollectionViewCell {
    var didTapMenu: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var pictureView = makePictureView()
    lazy var titleLabel = makeLabel()
    lazy var additionalLabel = makeLabel()
    lazy var menuButton = makeMenuButton()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Quicksand.bold(size: 21.scale))
        .lineHeight(26.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    private lazy var additionalAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.SFPro.regular(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    
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
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension ITLastAddedCollectionCell {
    func setup(product: Product) {
        pictureView.kf.setImage(with: product.image)
        
        titleLabel.attributedText = product.title.attributed(with: titleAttrs)
        
        let unitLocalized = String.choosePluralForm(
            byNumber: product.count,
            one: "Unit.One".localized,
            two: "Unit.Two".localized,
            many: "Unit.Many".localized
        )
        let countLocalized = String(format: "%i %@", product.count, unitLocalized)
        let additional = [countLocalized, product.barcode].joined(separator: "  ")
        additionalLabel.attributedText = additional.attributed(with: additionalAttrs)
    }
}

// MARK: Private
private extension ITLastAddedCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func menuTapped() {
        didTapMenu?()
    }
}

// MARK: Make constraints
private extension ITLastAddedCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 66.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 66.scale),
            pictureView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            pictureView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            titleLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            additionalLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            additionalLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            additionalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 19.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 20.scale),
            menuButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            menuButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ITLastAddedCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePictureView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Items.Product.Menu"), for: .normal)
        view.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
