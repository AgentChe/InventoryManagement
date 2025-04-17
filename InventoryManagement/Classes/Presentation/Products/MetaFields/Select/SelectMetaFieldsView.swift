//
//  SelectMetaFieldsView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit

final class SelectMetaFieldsView: UIView {
    lazy var grabberView = makeGrabberView()
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    
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
private extension SelectMetaFieldsView {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
    }
}

// MARK: Make constraints
private extension SelectMetaFieldsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            grabberView.widthAnchor.constraint(equalToConstant: 36.scale),
            grabberView.heightAnchor.constraint(equalToConstant: 5.scale),
            grabberView.centerXAnchor.constraint(equalTo: centerXAnchor),
            grabberView.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectMetaFieldsView {
    func makeGrabberView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2.5.scale
        view.backgroundColor = Appearance.custom60_60_67.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Quicksand.bold(size: 32.scale))
            .lineHeight(40.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "SelectMetaFields.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> SMFTableView {
        let view = SMFTableView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 19.scale)
        view.setContentOffset(CGPoint(x: 0, y: -19.scale), animated: false)
        view.separatorColor = Appearance.main200.withAlphaComponent(0.1)
        view.separatorInset = UIEdgeInsets(horizontal: 16.scale)
        view.separatorStyle = .singleLine
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
