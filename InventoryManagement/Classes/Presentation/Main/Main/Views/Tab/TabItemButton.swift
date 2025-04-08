//
//  TabItemButton.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 08.09.2024.
//

import UIKit

final class TabItemButton: UIButton {
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.main200)
        .font(Fonts.SFPro.medium(size: 10.scale))
        .lineHeight(12.scale)
        .textAlignment(.center)
    private lazy var normalAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 10.scale))
        .lineHeight(12.scale)
        .textAlignment(.center)
    
    private let domain: String
    
    init(domain: String) {
        self.domain = domain
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabItemButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        alpha = marked ? 1 : 0.3
        
        let iconName = domain + (marked ? ".S" : ".D")
        iconView.image = UIImage(named: iconName)
        
        let attrs = marked ? selectedAttrs : normalAttrs
        label.attributedText = domain.localized.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension TabItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemButton {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
