//
//  ItemsViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 21.04.2025.
//

import RxSwift
import RxCocoa

final class ItemsViewModel {
    private lazy var productsManager = ProductsManager()
    private lazy var foldersManager = FoldersManager()
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension ItemsViewModel {
    struct Input {}
    
    struct Output {
        let elements: Driver<[ItemsTableElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(
                statistics: makeStatistics(),
                folders: makeFolders(),
                allProducts: makeAllProducts(),
                activeSubscription: makeActiveSubscription()
            )
        )
    }
}

// MARK: Private
private extension ItemsViewModel {
    func makeElements(
        statistics: Driver<ProfileStatistics?>,
        folders: Driver<[Folder]>,
        allProducts: Driver<[Product]>,
        activeSubscription: Driver<Bool>
    ) -> Driver<[ItemsTableElement]> {
        Driver
            .combineLatest(statistics, folders, allProducts, activeSubscription)
            .map { statistics, folders, allProducts, activeSubscription -> [ItemsTableElement] in
                if let statistics {
                    var elements: [ItemsTableElement] = [
                        .title,
                        .statistics(statistics.statistics)
                    ]
                    
                    if !statistics.lastAddedProducts.isEmpty {
                        let title = ITBlockTitleElement(
                            block: .lastAdded,
                            seeAllHidden: true
                        )
                        elements.append(.block(title))
                        
                        elements.append(.lastAdded(statistics.lastAddedProducts))
                    }
                    
                    if !activeSubscription {
                        elements.append(.unlockAccess)
                    }
                    
                    let foldersTitle = ITBlockTitleElement(
                        block: .folders,
                        seeAllHidden: false
                    )
                    elements.append(.block(foldersTitle))
                    elements.append(.folders(folders))
                    
                    if !allProducts.isEmpty {
                        let title = ITBlockTitleElement(
                            block: .allItems,
                            seeAllHidden: false
                        )
                        elements.append(.block(title))
                        
                        allProducts.forEach { product in
                            elements.append(.product(product))
                        }
                    }
                    
                    return elements
                } else {
                    var elements: [ItemsTableElement] = [.addFirst]
                    
                    if !activeSubscription {
                        elements.append(.unlockAccess)
                    }
                    
                    let demoTitle = ITBlockTitleElement(
                        block: .demoItems,
                        seeAllHidden: true
                    )
                    elements.append(.block(demoTitle))
                    
                    let demoProduct1 = DemoProduct(product: .stanleyCup)
                    elements.append(.demoProduct(demoProduct1))
                    
                    let demoProduct2 = DemoProduct(product: .vitaminC)
                    elements.append(.demoProduct(demoProduct2))
                    
                    elements.append(.statistics(Statistics()))
                    
                    let foldersTitle = ITBlockTitleElement(
                        block: .folders,
                        seeAllHidden: false
                    )
                    elements.append(.block(foldersTitle))
                    elements.append(.folders(folders))
                    
                    return elements
                }
            }
    }
    
    func makeStatistics() -> Driver<ProfileStatistics?> {
        let trigger = Signal<Void>
            .merge(
                FoldersMediator.shared.didCreated.map { _ in Void() },
                FoldersMediator.shared.didDeleted.map { _ in Void() },
                ProductsMediator.shared.didCreatedProduct.map { _ in Void() },
                ProductsMediator.shared.didEditedProduct.map { _ in Void() },
                ProductsMediator.shared.didDeletedProduct.map { _ in Void() }
            )
            .startWith(())
            .asDriver(onErrorDriveWith: .never())
        
        return trigger
            .flatMapLatest { [weak self] void -> Driver<ProfileStatistics?> in
                guard let self else { return .never() }
                
                return profileManager
                    .obtainStatistics()
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeFolders() -> Driver<[Folder]> {
        let trigger = Signal<Void>
            .merge(
                FoldersMediator.shared.didCreated.map { _ in Void() },
                FoldersMediator.shared.didRenamed.map { _ in Void() },
                FoldersMediator.shared.didDeleted.map { _ in Void() }
            )
            .startWith(())
            .asDriver(onErrorDriveWith: .never())
        
        return trigger
            .flatMapLatest { [weak self] void -> Driver<[Folder]> in
                guard let self else { return .never() }
                
                return foldersManager
                    .obtain(page: 1)
                    .map { $0?.elements ?? [] }
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeAllProducts() -> Driver<[Product]> {
        let trigger = Signal<Void>
            .merge(
                ProductsMediator.shared.didCreatedProduct,
                ProductsMediator.shared.didDeletedProduct.map { _ in Void() },
                ProductsMediator.shared.didEditedProduct.map { _ in Void() }
            )
            .startWith(())
            .asDriver(onErrorDriveWith: .never())
        
        return trigger
            .flatMapLatest { [weak self] void -> Driver<[Product]> in
                guard let self else { return .never() }
                
                return productsManager
                    .obtainProducts(page: 1)
                    .map { $0?.elements ?? [] }
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .asDriver(onErrorDriveWith: .never())
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
    }
}
