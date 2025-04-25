//
//  AllProductsViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import RxSwift
import RxCocoa

final class AllProductsViewModel {
    enum Action {
        case openMenu(Product)
        case openDetails(Product)
        case openPaygate
        case createNewProduct
        case toast(String)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
    private lazy var foldersManager = FoldersManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension AllProductsViewModel {
    struct Input {
        let didScrollToBottom: Signal<Void>
        let didTapMenu: Signal<Product>
        let didSelectProduct: Signal<Product>
        let didTapCreateProduct: Signal<Void>
        let didDuplicateProduct: Signal<Product>
        let didMoveToFolder: Signal<(Product, Folder)>
        let didDeleteProduct: Signal<Product>
    }
    
    struct Output {
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let elements: Driver<[Product]>
        let action: Driver<Action>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let didStartFirstLoad = Signal
            .merge(
                ProductsMediator.shared.didEditedProduct.map { _ in Void() },
                ProductsMediator.shared.didDuplicatedProduct.map { _ in Void() },
                ProductsMediator.shared.didCreatedProduct.map { _ in Void() }
            )
            .startWith(())
            .asDriver(onErrorDriveWith: .never())
        let fetchPageProducts = makePageProducts(
            didStartFirstLoad: didStartFirstLoad,
            didScrollToBottom: input.didScrollToBottom
        )
        let allProducts = makeAllProducts(
            didStartFirstLoad: didStartFirstLoad,
            fetchPageProducts: fetchPageProducts
        )
        let firstPageActivity = firstPageActivity.asDriver()
        
        return Output(
            firstPageActivity: firstPageActivity,
            paginationActivity: paginationActivity.asDriver(),
            elements: allProducts,
            action: makeAction(
                didTapMenu: input.didTapMenu,
                didSelectProduct: input.didSelectProduct,
                didTapCreateProduct: input.didTapCreateProduct,
                didDuplicateProduct: input.didDuplicateProduct,
                didMoveToFolder: input.didMoveToFolder,
                didDeleteProduct: input.didDeleteProduct
            ),
            isEmpty: allProducts.map { $0.isEmpty }
        )
    }
}

// MARK: Private
private extension AllProductsViewModel {
    func makeAction(
        didTapMenu: Signal<Product>,
        didSelectProduct: Signal<Product>,
        didTapCreateProduct: Signal<Void>,
        didDuplicateProduct: Signal<Product>,
        didMoveToFolder: Signal<(Product, Folder)>,
        didDeleteProduct: Signal<Product>
    ) -> Driver<Action> {
        let openMenu = didTapMenu
            .map { product -> Action in
                SessionManager().hasActiveSubscriptions() ? .openMenu(product) : .openPaygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        let openDetails = didSelectProduct
            .map { product -> Action in
                SessionManager().hasActiveSubscriptions() ? .openDetails(product) : .openPaygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        let createNewProduct = didTapCreateProduct
            .map { void -> Action in
                SessionManager().hasActiveSubscriptions() ? .createNewProduct : .openPaygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        let duplicate = didDuplicateProduct
            .flatMap { [weak self] product -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    productsManager
                        .duplicate(id: product.id)
                        .map { result -> Action in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Action.toast("AllProducts.Duplicate".localized)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
            }
        
        let moveToFolder = didMoveToFolder
            .flatMap { [weak self] product, folder -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    foldersManager
                        .move(
                            targetFolderId: folder.id,
                            productId: product.id
                        )
                        .map { result -> Action in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Action.toast("AllProducts.MoveToFolder".localized)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
            }
        
        let delete = didDeleteProduct
            .flatMap { [weak self] product -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    productsManager
                        .delete(id: product.id)
                        .map { result -> Action in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Action.toast("AllProducts.Delete".localized)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(
                openMenu,
                openDetails,
                createNewProduct,
                duplicate,
                moveToFolder,
                delete
            )
    }
    
    func makeAllProducts(
        didStartFirstLoad: Driver<Void>,
        fetchPageProducts: Driver<Page<[Product]>>
    ) -> Driver<[Product]> {
        enum Action {
            case startSearch
            case fetch(Page<[Product]>)
            case delete(String)
        }
        
        let action = Driver
            .merge(
                didStartFirstLoad
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Action.startSearch },
                fetchPageProducts
                    .map { Action.fetch($0) },
                ProductsMediator.shared.didDeletedProduct
                    .asDriver(onErrorDriveWith: .never())
                    .map { Action.delete($0) }
            )
        
        return action
            .scan([]) { allProducts, action -> [Product] in
                switch action {
                case .startSearch:
                    return []
                case .fetch(let page):
                    return page.info.current == 1 ? page.elements : (allProducts + page.elements)
                case .delete(let id):
                    var result = allProducts
                    result.removeAll(where: { $0.id == id })
                    return result
                }
            }
            .startWith([])
    }
    
    func makePageProducts(
        didStartFirstLoad: Driver<Void>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Page<[Product]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[Product]>> {
            productsManager
                .obtainProducts(page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = didStartFirstLoad
            .flatMapLatest { void -> Driver<Page<[Product]>> in
                fetch(page: 1)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Product]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .compactMap { lastPageInfo }
                    .filter { lastPageInfo -> Bool in
                        let nextPageNotTotal = lastPageInfo.next <= lastPageInfo.total
                        let currentNotTotal = lastPageInfo.current != lastPageInfo.total
                        return nextPageNotTotal && currentNotTotal
                    }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[Product]>> in
                        fetch(page: lastPageInfo.next)
                    }
                    .startWith(firstPage)
            }
        return downloadedPage
    }
}
