//
//  CreateDateField.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateDateField: CreateProductFieldView {
    lazy var nameField = makeNameField()
    lazy var valueTitleLabel = makeValueTitleLabel()
    lazy var dateTypeView = makeDateTypeView()
    lazy var datePicker = makeDatePicker()
    
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
extension CreateDateField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension CreateDateField {
    func initialize() {
        backgroundColor = Appearance.custom245_246_250
        
        let dateType = Driver
            .merge(
                dateTypeView.todayButton.rx.tap
                    .map { CreateDateTypeView.DateType.today }
                    .asDriver(onErrorDriveWith: .never()),
                dateTypeView.tomorrowButton.rx.tap
                    .map{ CreateDateTypeView.DateType.tomorrow }
                    .asDriver(onErrorDriveWith: .never()),
                dateTypeView.customButton.rx.tap
                    .map{ CreateDateTypeView.DateType.custom }
                    .asDriver(onErrorDriveWith: .never())
            )
            .startWith(.today)
        
        dateType
            .asObservable()
            .enumerated()
            .bind(to: Binder(dateTypeView) { base, args in
                let (index, dateType) = args
                base.setup(dateType: dateType, animate: index != 0)
            })
            .disposed(by: disposeBag)
        
        dateType
            .drive(Binder(self) { base, dateType in
                base.datePicker.isHidden = dateType != .custom
            })
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .bind(to: Binder(dateTypeView.customButton) { base, date in
                base.date = date
            })
            .disposed(by: disposeBag)
        
        let currentDate = Date()
        dateTypeView.todayButton.date = currentDate
        dateTypeView.tomorrowButton.date = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
        dateTypeView.customButton.date = currentDate
        datePicker.date = currentDate
    }
    
    @objc
    func textEditing() {
        let name = (nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        didChangeEnable?(!name.isEmpty)
    }
}

// MARK: Make constraints
private extension CreateDateField {
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
            dateTypeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            dateTypeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            dateTypeView.topAnchor.constraint(equalTo: valueTitleLabel.bottomAnchor, constant: 18.scale),
            dateTypeView.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            datePicker.topAnchor.constraint(equalTo: dateTypeView.bottomAnchor, constant: 20.scale),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateDateField {
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
        view.attributedPlaceholder = "CreateMetaField.Date.Value.Name.Placeholder".localized.attributed(with: placeholderAttrs)
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
        view.attributedText = "CreateMetaField.Date.Value.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDateTypeView() -> CreateDateTypeView {
        let view = CreateDateTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.overrideUserInterfaceStyle = .light
        view.backgroundColor = Appearance.mono100
        view.datePickerMode = .date
        view.tintColor = Appearance.main200
        view.preferredDatePickerStyle = .inline
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
