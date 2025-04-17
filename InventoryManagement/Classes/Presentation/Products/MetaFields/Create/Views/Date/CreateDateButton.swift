//
//  CreateDateButton.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit

final class CreateDateButton: UIButton {
    var marked = false {
        didSet {
            update()
        }
    }
    
    var date: Date? {
        didSet {
            update()
        }
    }
    
    lazy var container = makeContainer()
    lazy var nameLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    
    private lazy var selectedNameAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SFPro.medium(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.center)
    private lazy var selectedDateAttrs = TextAttributes()
        .textColor(Appearance.mono100.withAlphaComponent(0.6))
        .font(Fonts.SFPro.regular(size: 12.scale))
        .lineHeight(14.scale)
        .textAlignment(.center)
    private lazy var normalNameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.center)
    private lazy var normalDateAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.4))
        .font(Fonts.SFPro.regular(size: 12.scale))
        .lineHeight(14.scale)
        .textAlignment(.center)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private let name: String
    
    init(name: String) {
        self.name = name
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CreateDateButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        let nameAttrs = marked ? selectedNameAttrs : normalNameAttrs
        nameLabel.attributedText = name.attributed(with: nameAttrs)
        
        if let date {
            let dateAttrs = marked ? selectedDateAttrs : normalDateAttrs
            dateLabel.attributedText = dateFormatter.string(from: date).attributed(with: dateAttrs)
        }
    }
}

// MARK: Make Constraints
private extension CreateDateButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2.scale),
            dateLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateDateButton {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
