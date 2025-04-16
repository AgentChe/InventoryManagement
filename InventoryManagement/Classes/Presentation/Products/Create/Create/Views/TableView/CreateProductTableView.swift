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
    private lazy var didTapAddPhotoTrigger = PublishRelay<Void>()
    private lazy var changedTitleTrigger = PublishRelay<String>()
    private lazy var changedCountTrigger = PublishRelay<Int>()
    private lazy var changedPriceTrigger = PublishRelay<Double>()
    private lazy var changedPriceCurrencyTrigger = PublishRelay<PriceCurrency>()
    
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
    
    var didTapAddPhoto: Signal<Void> {
        didTapAddPhotoTrigger.asSignal()
    }
    
    var changedTitle: Signal<String> {
        changedTitleTrigger.asSignal()
    }
    
    var changedCount: Signal<Int> {
        changedCountTrigger.asSignal()
    }
    
    var changedPrice: Signal<Double> {
        changedPriceTrigger.asSignal()
    }
    
    var changedPriceCurrency: Signal<PriceCurrency> {
        changedPriceCurrencyTrigger.asSignal()
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
        }
    }
}

// MARK: UITableViewDelegate
extension CreateProductTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension CreateProductTableView {
    func initialize() {
        register(CPTableGeneralCell.self, forCellReuseIdentifier: String(describing: CPTableGeneralCell.self))
        
        dataSource = self
        delegate = self
    }
}
