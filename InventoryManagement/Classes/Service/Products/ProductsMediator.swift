//
//  ProductsMediator.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import RxSwift
import RxCocoa

final class ProductsMediator {
    static let shared = ProductsMediator()
    
    private lazy var didCreatedProductTrigger = PublishRelay<Void>()
    private lazy var didEditedProductTrigger = PublishRelay<String>()
    private lazy var didDeletedProductTrigger = PublishRelay<String>()
    private lazy var didDuplicatedProductTrigger = PublishRelay<Void>()
    
    private init() {}
}

// MARK: Public
extension ProductsMediator {
    func notifyCreateProduct() {
        didCreatedProductTrigger.accept(Void())
    }
    
    func notifyEditeProduct(id: String) {
        didEditedProductTrigger.accept(id)
    }
    
    func notifyDeleteProduct(id: String) {
        didDeletedProductTrigger.accept(id)
    }
    
    func notifyDuplicateProduct() {
        didDuplicatedProductTrigger.accept(Void())
    }
    
    var didCreatedProduct: Signal<Void> {
        didCreatedProductTrigger.asSignal()
    }
    
    var didEditedProduct: Signal<String> {
        didEditedProductTrigger.asSignal()
    }
    
    var didDeletedProduct: Signal<String> {
        didDeletedProductTrigger.asSignal()
    }
    
    var didDuplicatedProduct: Signal<Void> {
        didDuplicatedProductTrigger.asSignal()
    }
}
