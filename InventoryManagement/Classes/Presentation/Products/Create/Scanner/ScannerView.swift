//
//  ScannerView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import UIKit

final class ScannerView: UIView {
    lazy var overlayView = makeOverlayView()
    lazy var controlsView = makeControlsView()
    
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
private extension ScannerView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension ScannerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            overlayView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 23.scale),
            overlayView.bottomAnchor.constraint(equalTo: controlsView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            controlsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            controlsView.heightAnchor.constraint(equalToConstant: 152.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ScannerView {
    func makeOverlayView() -> ScannerOverlayView {
        let view = ScannerOverlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeControlsView() -> ScannerControlsView {
        let view = ScannerControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
