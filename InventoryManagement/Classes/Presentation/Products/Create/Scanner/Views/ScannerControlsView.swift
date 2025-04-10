//
//  ScannerControlsView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import UIKit

final class ScannerControlsView: UIView {
    lazy var wallpapersButton = makeWallpapersButton()
    lazy var flashButton = makeFlashButton()
    
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
private extension ScannerControlsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension ScannerControlsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            wallpapersButton.widthAnchor.constraint(equalToConstant: 32.scale),
            wallpapersButton.heightAnchor.constraint(equalToConstant: 32.scale),
            wallpapersButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46.scale),
            wallpapersButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            flashButton.widthAnchor.constraint(equalToConstant: 24.scale),
            flashButton.heightAnchor.constraint(equalToConstant: 24.scale),
            flashButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -46.scale),
            flashButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ScannerControlsView {
    func makeWallpapersButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Scanner.Wallpapers"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFlashButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Scanner.Flash"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
