//
//  CreateFolderView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit
import RxSwift

final class CreateFolderView: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    lazy var saveButton = makeSaveButton()
    lazy var preloader = makePreloader()
    
    private lazy var containerYConstraint = NSLayoutConstraint()
    
    private lazy var disposeBag = DisposeBag()
    
    private let mode: CreateFolderViewController.Mode
    
    init(mode: CreateFolderViewController.Mode) {
        self.mode = mode
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        textEditing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CreateFolderView {
    func animateShow() {
        containerYConstraint.isActive = false
        containerYConstraint = container.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.scale)
        containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.alpha = 0.3
            self?.layoutIfNeeded()
        }, completion: { [weak self] result in
            self?.subscribeKeyboardChange()
        })
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        containerYConstraint.isActive = false
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.alpha = 0
            self?.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}

// MARK: UITextFieldDelegate
extension CreateFolderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension CreateFolderView {
    func initialize() {
        textField.text = {
            switch mode {
            case .create:
                return nil
            case .edit(let folder):
                return folder.title
            }
        }()
    }
    
    func subscribeKeyboardChange() {
        rx.keyboardHeight
            .bind(to: Binder(self) { base, keyboardHeight in
                base.containerYConstraint.isActive = false
                
                let offset = keyboardHeight > 0 ? keyboardHeight : 16.scale
                base.containerYConstraint.constant = -offset
                
                base.containerYConstraint.isActive = true
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func textEditing() {
        let text = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let isEmpty = text.isEmpty
        saveButton.alpha = isEmpty ? 0.5 : 1
        saveButton.isEnabled = !isEmpty
    }
}

// MARK: Make constraints
private extension CreateFolderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            containerYConstraint,
            container.heightAnchor.constraint(equalToConstant: 289.scale),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 60.scale),
            saveButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -21.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateFolderView {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = Appearance.mono200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Quicksand.bold(size: 27.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let title: String = {
            switch mode {
            case .create:
                return "CreateFolder.Title.Create".localized
            case .edit:
                return "CreateFolder.Title.Edit".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.2))
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = PaddingTextField()
        view.layer.cornerRadius = 24.scale
        view.layer.masksToBounds = true
        view.backgroundColor = Appearance.custom245_246_250
        view.delegate = self
        view.returnKeyType = .default
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "CreateFolder.Placeholder".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 20.scale, horizontal: 16.scale)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.regular(size: 17.scale))
        
        let title: String = {
            switch mode {
            case .create:
                return "Continue".localized
            case .edit:
                return "Save".localized
            }
        }()
        
        let view = UIButton()
        view.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
