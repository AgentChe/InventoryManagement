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
    
    private init() {}
}

// MARK: Public
extension ProductsMediator {
    func notifyCreateProduct() {
        didCreatedProductTrigger.accept(Void())
    }
    
    var didCreatedProduct: Signal<Void> {
        didCreatedProductTrigger.asSignal()
    }
}
