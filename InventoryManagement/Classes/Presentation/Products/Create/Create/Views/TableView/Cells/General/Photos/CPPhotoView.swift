//
//  CPPhotoView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import UIKit

final class CPPhotoView: UIView {
    var didTapAddPhoto: (() -> Void)?
    
    lazy var photoView = makePhotoView()
    lazy var addPhotoButton = makeAddPhotoButton()
    
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
extension CPPhotoView {
    func setup(selectedPhoto: URL?) {
        let empty = selectedPhoto == nil
        photoView.isHidden = empty
        addPhotoButton.isHidden = !empty
        
        photoView.kf.cancelDownloadTask()
        photoView.image = nil
        photoView.kf.setImage(with: selectedPhoto)
    }
}

// MARK: Private
private extension CPPhotoView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func addTapped() {
        didTapAddPhoto?()
    }
}

// MARK: Make constraints
private extension CPPhotoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoView.topAnchor.constraint(equalTo: topAnchor),
            photoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoButton.widthAnchor.constraint(equalToConstant: 63.scale),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 53.scale),
            addPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CPPhotoView {
    func makePhotoView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddPhotoButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CreateProduct.NotPhoto"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
