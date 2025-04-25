//
//  SearchViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import RxSwift
import RxCocoa

final class SearchViewModel {
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
extension SearchViewModel {
    struct Input {
        let didChangedInputText: Signal<String>
        let didTapSearch: Signal<Void>
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
        let startSearch = Signal
            .merge(
                input.didTapSearch.startWith(()),
                ProductsMediator.shared.didEditedProduct.map { _ in Void() },
                ProductsMediator.shared.didDuplicatedProduct.map { _ in Void() },
                ProductsMediator.shared.didCreatedProduct.map { _ in Void() }
            )
            .asDriver(onErrorDriveWith: .never())
        let inputText = input.didChangedInputText
            .asDriver(onErrorDriveWith: .never())
            .startWith("")
        let fetchPageProducts = makePageProducts(
            startSearch: startSearch,
            inputText: inputText,
            didScrollToBottom: input.didScrollToBottom
        )
        let allProducts = makeAllProducts(
            startSearch: startSearch,
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
private extension SearchViewModel {
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
                            
                            return Action.toast("Search.Duplicate".localized)
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
                            currentFolderId: product.folderId,
                            targetFolderId: folder.id,
                            productId: product.id
                        )
                        .map { result -> Action in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Action.toast("Search.MoveToFolder".localized)
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
                            
                            return Action.toast("Search.Delete".localized)
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
        startSearch: Driver<Void>,
        fetchPageProducts: Driver<Page<[Product]>>
    ) -> Driver<[Product]> {
        enum Action {
            case startSearch
            case fetch(Page<[Product]>)
            case delete(String)
        }
        
        let action = Driver
            .merge(
                startSearch
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
        startSearch: Driver<Void>,
        inputText: Driver<String>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Page<[Product]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, inputText: String) -> Driver<Page<[Product]>> {
            productsManager
                .obtainProducts(
                    search: inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : inputText,
                    page: page
                )
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = startSearch
            .withLatestFrom(inputText)
            .flatMapLatest { inputText -> Driver<Page<[Product]>> in
                fetch(page: 1, inputText: inputText)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Product]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(inputText)
                    .compactMap { inputText -> (String, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (inputText, lastPageInfo)
                    }
                    .filter { _, lastPageInfo -> Bool in
                        let nextPageNotTotal = lastPageInfo.next <= lastPageInfo.total
                        let currentNotTotal = lastPageInfo.current != lastPageInfo.total
                        return nextPageNotTotal && currentNotTotal
                    }
                    .flatMapFirst { inputText, lastPageInfo -> Driver<Page<[Product]>> in
                        fetch(page: lastPageInfo.next, inputText: inputText)
                    }
                    .startWith(firstPage)
            }
        return downloadedPage
    }
}
