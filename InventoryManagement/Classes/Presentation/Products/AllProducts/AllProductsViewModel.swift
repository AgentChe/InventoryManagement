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
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
}

// MARK: Public
extension AllProductsViewModel {
    struct Input {
        let didScrollToBottom: Signal<Void>
        let didTapMenu: Signal<Product>
        let didSelectProduct: Signal<Product>
        let didTapCreateProduct: Signal<Void>
    }
    
    struct Output {
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let elements: Driver<[Product]>
        let action: Driver<Action>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let didStartFirstLoad = ProductsMediator.shared.didCreatedProduct
            .map { _ in Void() }
            .asDriver(onErrorDriveWith: .never())
            .startWith(())
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
                didTapCreateProduct: input.didTapCreateProduct
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
        didTapCreateProduct: Signal<Void>
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
        
        return Driver
            .merge(openMenu, openDetails, createNewProduct)
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
