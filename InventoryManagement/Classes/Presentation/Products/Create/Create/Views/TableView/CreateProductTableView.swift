//
//  CreateProductTableView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateProductTableView: UITableView {
    weak var vc: UIViewController?
    
    private lazy var elements = [CreateProductTableElement]()
    
    private lazy var didSelectPhotoTrigger = PublishRelay<URL>()
    private lazy var didDeletePhotoTrigger = PublishRelay<URL>()
    private lazy var didTapAddPhotoTrigger = PublishRelay<Void>()
    private lazy var changedTitleTrigger = PublishRelay<String>()
    private lazy var changedCountTrigger = PublishRelay<Int?>()
    private lazy var changedPriceTrigger = PublishRelay<Double?>()
    private lazy var changedPriceCurrencyTrigger = PublishRelay<PriceCurrency>()
    private lazy var didTapAddFieldsTrigger = PublishRelay<Void>()
    private lazy var didTapAddBarcodeTrigger = PublishRelay<Void>()
    private lazy var didTapSaveTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CreateProductTableView {
    func setup(elements: [CreateProductTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectPhoto: Signal<URL> {
        didSelectPhotoTrigger.asSignal()
    }
    
    var didDeletePhoto: Signal<URL> {
        didDeletePhotoTrigger.asSignal()
    }
    
    var didTapAddPhoto: Signal<Void> {
        didTapAddPhotoTrigger.asSignal()
    }
    
    var changedTitle: Signal<String> {
        changedTitleTrigger.asSignal()
    }
    
    var changedCount: Signal<Int?> {
        changedCountTrigger.asSignal()
    }
    
    var changedPrice: Signal<Double?> {
        changedPriceTrigger.asSignal()
    }
    
    var changedPriceCurrency: Signal<PriceCurrency> {
        changedPriceCurrencyTrigger.asSignal()
    }
    
    var didTapAddFields: Signal<Void> {
        didTapAddFieldsTrigger.asSignal()
    }
    
    var didTapAddBarcode: Signal<Void> {
        didTapAddBarcodeTrigger.asSignal()
    }
    
    var didTapSave: Signal<Void> {
        didTapSaveTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension CreateProductTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .general(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CPTableGeneralCell.self), for: indexPath) as! CPTableGeneralCell
            cell.generalInputView.priceField.vc = vc
            cell.setup(element: element)
            cell.collectionView.didSelectPhoto = { [weak self] url in
                self?.didSelectPhotoTrigger.accept(url)
            }
            cell.collectionView.didDeletePhoto = { [weak self] url in
                self?.didDeletePhotoTrigger.accept(url)
            }
            cell.collectionView.didTapAdd = { [weak self] in
                self?.didTapAddPhotoTrigger.accept(Void())
            }
            cell.photoView.didTapAddPhoto = { [weak self] in
                self?.didTapAddPhotoTrigger.accept(Void())
            }
            cell.generalInputView.titleField.changedText = { [weak self] text in
                self?.changedTitleTrigger.accept(text)
            }
            cell.generalInputView.countField.changedValue = { [weak self] count in
                self?.changedCountTrigger.accept(count)
            }
            cell.generalInputView.priceField.changedPrice = { [weak self] price in
                self?.changedPriceTrigger.accept(price)
            }
            cell.generalInputView.priceField.changedCurrency = { [weak self] currency in
                self?.changedPriceCurrencyTrigger.accept(currency)
            }
            return cell
        case .addFields:
            return dequeueReusableCell(withIdentifier: String(describing: CPTableAddFieldCell.self), for: indexPath)
        case .barcode(let barcode):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CPTableBarcodeCell.self), for: indexPath) as! CPTableBarcodeCell
            cell.setup(barcode: barcode)
            return cell
        case .addBarcode:
            return dequeueReusableCell(withIdentifier: String(describing: CPTableAddBarcodeCell.self), for: indexPath)
        case .save(let enable):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CPTableSaveCell.self), for: indexPath) as! CPTableSaveCell
            cell.setup(enable: enable)
            return cell
        case .metaField(let element):
            switch element {
            case .smallTextBox(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTSmallTextBoxFieldCell.self), for: indexPath) as! CPTSmallTextBoxFieldCell
                cell.setup(element: element)
                return cell
            case .largeTextBox(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTLargeTextBoxFieldCell.self), for: indexPath) as! CPTLargeTextBoxFieldCell
                cell.setup(element: element)
                return cell
            case .roundNumber(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTRoundNumberFieldCell.self), for: indexPath) as! CPTRoundNumberFieldCell
                cell.setup(element: element)
                return cell
            case .decimalNumber(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTDecimalNumberFieldCell.self), for: indexPath) as! CPTDecimalNumberFieldCell
                cell.setup(element: element)
                return cell
            case .checkBox(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTCheckboxFieldCell.self), for: indexPath) as! CPTCheckboxFieldCell
                cell.setup(element: element)
                return cell
            case .date(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTDateFieldCell.self), for: indexPath) as! CPTDateFieldCell
                cell.setup(element: element)
                return cell
            case .phoneNumber(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTPhoneNumberFieldCell.self), for: indexPath) as! CPTPhoneNumberFieldCell
                cell.setup(element: element)
                return cell
            case .webLink(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTWebLinkFieldCell.self), for: indexPath) as! CPTWebLinkFieldCell
                cell.setup(element: element)
                return cell
            case .email(let element):
                let cell = dequeueReusableCell(withIdentifier: String(describing: CPTEmailFieldCell.self), for: indexPath) as! CPTEmailFieldCell
                cell.setup(element: element)
                return cell
            }
        }
    }
}

// MARK: UITableViewDelegate
extension CreateProductTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .addFields:
            didTapAddFieldsTrigger.accept(Void())
        case .addBarcode:
            didTapAddBarcodeTrigger.accept(Void())
        case .save(let enable):
            if enable { didTapSaveTrigger.accept(Void()) }
        default:
            return
        }
    }
}

// MARK: Private
private extension CreateProductTableView {
    func initialize() {
        register(CPTableGeneralCell.self, forCellReuseIdentifier: String(describing: CPTableGeneralCell.self))
        register(CPTableAddFieldCell.self, forCellReuseIdentifier: String(describing: CPTableAddFieldCell.self))
        register(CPTableBarcodeCell.self, forCellReuseIdentifier: String(describing: CPTableBarcodeCell.self))
        register(CPTableAddBarcodeCell.self, forCellReuseIdentifier: String(describing: CPTableAddBarcodeCell.self))
        register(CPTableSaveCell.self, forCellReuseIdentifier: String(describing: CPTableSaveCell.self))
        register(CPTSmallTextBoxFieldCell.self, forCellReuseIdentifier: String(describing: CPTSmallTextBoxFieldCell.self))
        register(CPTLargeTextBoxFieldCell.self, forCellReuseIdentifier: String(describing: CPTLargeTextBoxFieldCell.self))
        register(CPTRoundNumberFieldCell.self, forCellReuseIdentifier: String(describing: CPTRoundNumberFieldCell.self))
        register(CPTDecimalNumberFieldCell.self, forCellReuseIdentifier: String(describing: CPTDecimalNumberFieldCell.self))
        register(CPTCheckboxFieldCell.self, forCellReuseIdentifier: String(describing: CPTCheckboxFieldCell.self))
        register(CPTDateFieldCell.self, forCellReuseIdentifier: String(describing: CPTDateFieldCell.self))
        register(CPTPhoneNumberFieldCell.self, forCellReuseIdentifier: String(describing: CPTPhoneNumberFieldCell.self))
        register(CPTWebLinkFieldCell.self, forCellReuseIdentifier: String(describing: CPTWebLinkFieldCell.self))
        register(CPTEmailFieldCell.self, forCellReuseIdentifier: String(describing: CPTEmailFieldCell.self))
        
        dataSource = self
        delegate = self
    }
}
