//
//  CreateDateTypeView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit

final class CreateDateTypeView: UIView {
    enum DateType {
        case today, tomorrow, custom
    }
    
    lazy var cursor = makeCursor()
    lazy var todayButton = makeDateButton(name: "CreateMetaField.Date.Value.Today".localized)
    lazy var leftSeparator = makeSeparator()
    lazy var tomorrowButton = makeDateButton(name: "CreateMetaField.Date.Value.Tomorrow".localized)
    lazy var rightSeparator = makeSeparator()
    lazy var customButton = makeDateButton(name: "CreateMetaField.Date.Value.CustomDate".localized)
    
    private lazy var cursorXConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CreateDateTypeView {
    func setup(dateType: DateType, animate: Bool) {
        updateCursor(dateType: dateType, animate: animate)
        updateButtons(dateType: dateType)
        updateSeparators(dateType: dateType)
    }
}

// MARK: Private
private extension CreateDateTypeView {
    func initialize() {
        backgroundColor = Appearance.mono100
        layer.cornerRadius = 16.scale
        layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
    }
    
    func updateCursor(dateType: DateType, animate: Bool) {
        cursorXConstraint.isActive = false
        switch dateType {
        case .today:
            cursorXConstraint = cursor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.scale)
        case .tomorrow:
            cursorXConstraint = cursor.centerXAnchor.constraint(equalTo: tomorrowButton.centerXAnchor)
        case .custom:
            cursorXConstraint = cursor.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.scale)
        }
        cursorXConstraint.isActive = true
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
    }
    
    func updateButtons(dateType: DateType) {
        todayButton.marked = dateType == .today
        tomorrowButton.marked = dateType == .tomorrow
        customButton.marked = dateType == .custom
    }
    
    func updateSeparators(dateType: DateType) {
        leftSeparator.isHidden = (dateType == .today) || (dateType == .tomorrow)
        rightSeparator.isHidden = (dateType == .custom) || (dateType == .tomorrow)
    }
}

// MARK: Make constraints
private extension CreateDateTypeView {
    func makeConstraints() {
        cursorXConstraint = cursor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.scale)
        NSLayoutConstraint.activate([
            cursorXConstraint,
            cursor.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale),
            cursor.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.scale),
            cursor.widthAnchor.constraint(equalToConstant: 118.scale)
        ])
        
        NSLayoutConstraint.activate([
            todayButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            todayButton.trailingAnchor.constraint(equalTo: tomorrowButton.leadingAnchor),
            todayButton.topAnchor.constraint(equalTo: topAnchor),
            todayButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            todayButton.widthAnchor.constraint(equalTo: tomorrowButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            leftSeparator.leadingAnchor.constraint(equalTo: todayButton.trailingAnchor),
            leftSeparator.centerYAnchor.constraint(equalTo: todayButton.centerYAnchor),
            leftSeparator.widthAnchor.constraint(equalToConstant: 1.scale),
            leftSeparator.heightAnchor.constraint(equalToConstant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tomorrowButton.trailingAnchor.constraint(equalTo: customButton.leadingAnchor),
            tomorrowButton.topAnchor.constraint(equalTo: topAnchor),
            tomorrowButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            tomorrowButton.widthAnchor.constraint(equalTo: customButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightSeparator.leadingAnchor.constraint(equalTo: tomorrowButton.trailingAnchor),
            rightSeparator.centerYAnchor.constraint(equalTo: tomorrowButton.centerYAnchor),
            rightSeparator.widthAnchor.constraint(equalToConstant: 1.scale),
            rightSeparator.heightAnchor.constraint(equalToConstant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            customButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            customButton.topAnchor.constraint(equalTo: topAnchor),
            customButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateDateTypeView {
    func makeCursor() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDateButton(name: String) -> CreateDateButton {
        let view = CreateDateButton(name: name)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom142_142_147
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
