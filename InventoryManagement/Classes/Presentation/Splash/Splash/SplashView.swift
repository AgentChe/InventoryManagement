//
//  SplashView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class SplashView: UIView {
    lazy var imageView = makeImageView()
    lazy var preloaderLabel = makePreloaderLabel()
    
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
private extension SplashView {
    func initialize() {
        backgroundColor = Appearance.mono100
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 128.scale),
            imageView.heightAnchor.constraint(equalToConstant: 128.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            preloaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            preloaderLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -29.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Splash.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.Quicksand.regular(size: 17.scale))
            .lineHeight(23.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Splash.Preloader".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
