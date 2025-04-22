//
//  ITProductCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit

final class ITProductCell: UITableViewCell {
    var didTapMenu: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var pictureView = makePictureView()
    lazy var labelsContainer = makeLabelsContainer()
    lazy var titleLabel = makeLabel()
    lazy var additionalLabel = makeLabel()
    lazy var menuButton = makeMenuButton()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Quicksand.bold(size: 21.scale))
        .lineHeight(26.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var additionalAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.SFPro.regular(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
extension ITProductCell {
    func setup(element: Product) {
        pictureView.kf.setImage(with: element.image)
        
        titleLabel.attributedText = element.title.attributed(with: titleAttrs)
        
        let unitLocalized = String.choosePluralForm(
            byNumber: element.count,
            one: "Unit.One".localized,
            two: "Unit.Two".localized,
            many: "Unit.Many".localized
        )
        let countLocalized = String(format: "%i %@", element.count, unitLocalized)
        let additional = [countLocalized, element.barcode].joined(separator: "  ")
        additionalLabel.attributedText = additional.attributed(with: additionalAttrs)
    }
}

// MARK: Private
private extension ITProductCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func menuTapped() {
        didTapMenu?()
    }
}

// MARK: Make constraints
private extension ITProductCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 98.scale)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 66.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 66.scale),
            pictureView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            pictureView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            labelsContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 86.scale),
            labelsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -47.scale),
            labelsContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            additionalLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            additionalLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            additionalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            additionalLabel.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 19.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 20.scale),
            menuButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ITProductCell {
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
    
    func makeLabelsContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(view)
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
