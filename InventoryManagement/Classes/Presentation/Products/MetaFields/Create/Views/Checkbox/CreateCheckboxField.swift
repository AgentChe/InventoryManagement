//
//  CreateCheckboxField.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateCheckboxField: CreateProductFieldView {
    lazy var nameField = makeNameField()
    lazy var valueTitleLabel = makeValueTitleLabel()
    lazy var valuesView = makeValuesView()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func forceCheckEnable() {
        textEditing()
    }
}

// MARK: UITextFieldDelegate
extension CreateCheckboxField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension CreateCheckboxField {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
        
        let value = Signal
            .merge(
                valuesView.checkedButton.rx.tap
                    .map { CreateCheckboxValueView.Value.checked }
                    .asSignal(onErrorSignalWith: .never()),
                valuesView.uncheckedButton.rx.tap
                    .map { CreateCheckboxValueView.Value.unchecked }
                    .asSignal(onErrorSignalWith: .never())
            )
            .startWith(.checked)
        
        value
            .asObservable()
            .enumerated()
            .bind(to: Binder(valuesView) { base, args in
                let (index, value) = args
                base.setup(value: value, animate: index != 0)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func textEditing() {
        let name = (nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        didChangeEnable?(!name.isEmpty)
    }
}

// MARK: Make constraints
private extension CreateCheckboxField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameField.topAnchor.constraint(equalTo: topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            valueTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            valueTitleLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            valuesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            valuesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            valuesView.topAnchor.constraint(equalTo: valueTitleLabel.bottomAnchor, constant: 16.scale),
            valuesView.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateCheckboxField {
    func makeNameField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.2))
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = PaddingTextField()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.delegate = self
        view.returnKeyType = .done
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "CreateMetaField.Checkbox.Name.Placeholder".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(vertical: 20.scale, horizontal: 16.scale)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Quicksand.bold(size: 19.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "CreateMetaField.Checkbox.Value.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValuesView() -> CreateCheckboxValueView {
        let view = CreateCheckboxValueView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
