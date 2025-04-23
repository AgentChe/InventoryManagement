//
//  FolderProductsViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import RxSwift
import RxCocoa

final class FolderProductsViewModel {
    enum Action {
        case openProductMenu(Product)
        case openDetails(Product)
        case openPaygate
        case createNewProduct
        case openMenu
        case close
        case confirmDelete(Folder)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let initialFolder: Driver<Folder>
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var foldersManager = FoldersManager()
    private lazy var productsManager = ProductsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(folder: Folder) {
        self.initialFolder = BehaviorRelay(value: folder).asDriver()
    }
}

// MARK: Public
extension FolderProductsViewModel {
    struct Input {
        let didScrollToBottom: Signal<Void>
        let didTapProductMenu: Signal<Product>
        let didSelectProduct: Signal<Product>
        let didTapCreateProduct: Signal<Void>
        let didTapMenu: Signal<Void>
        let didTapDeleteFolder: Signal<Void>
        let didTapRenameFolder: Signal<Void>
        let didDeleteConfirmed: Signal<Void>
    }
    
    struct Output {
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let elements: Driver<[Product]>
        let action: Driver<Action>
        let isEmpty: Driver<Bool>
        let title: Driver<String>
    }
    
    func configure(input: Input) -> Output {
        let folder = makeFolder(initial: initialFolder)
        let didStartFirstLoad = Signal<Void>
            .merge(
                ProductsMediator.shared.didCreatedProduct.map { _ in Void() },
                ProductsMediator.shared.didDeletedProduct.map { _ in Void() },
                ProductsMediator.shared.didDeletedProduct.map { _ in Void() },
                FoldersMediator.shared.didMoved.map { _ in Void() },
                FoldersMediator.shared.didChanged.map { _ in Void() }
            )
            .asDriver(onErrorDriveWith: .never())
            .startWith(())
        let fetchPageProducts = makePageProducts(
            didStartFirstLoad: didStartFirstLoad,
            folder: folder,
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
                didTapProductMenu: input.didTapProductMenu,
                didSelectProduct: input.didSelectProduct,
                didTapCreateProduct: input.didTapCreateProduct,
                didTapMenu: input.didTapMenu,
                didTapDeleteFolder: input.didTapDeleteFolder,
                didDeleteConfirmed: input.didDeleteConfirmed,
                folder: folder
            ),
            isEmpty: allProducts.map { $0.isEmpty },
            title: folder.map { $0.title }
        )
    }
}

// MARK: Private
private extension FolderProductsViewModel {
    func makeFolder(initial: Driver<Folder>) -> Driver<Folder> {
        initial
    }
    
    func makeAction(
        didTapProductMenu: Signal<Product>,
        didSelectProduct: Signal<Product>,
        didTapCreateProduct: Signal<Void>,
        didTapMenu: Signal<Void>,
        didTapDeleteFolder: Signal<Void>,
        didDeleteConfirmed: Signal<Void>,
        folder: Driver<Folder>
    ) -> Driver<Action> {
        let openProductMenu = didTapProductMenu
            .map { product -> Action in
                SessionManager().hasActiveSubscriptions() ? .openProductMenu(product) : .openPaygate
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
        
        let openMenu = didTapMenu
            .map { Action.openMenu }
            .asDriver(onErrorDriveWith: .never())
        
        let confiremDelete = didTapDeleteFolder
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(folder)
            .map { Action.confirmDelete($0) }
        
        let delete = didDeleteConfirmed
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(folder)
            .flatMapLatest { [weak self] folder -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    foldersManager
                        .delete(id: folder.id)
                        .map { result -> Action in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Action.close
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
                openProductMenu,
                openDetails,
                createNewProduct,
                openMenu,
                confiremDelete,
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
        }
        
        let action = Driver
            .merge(
                didStartFirstLoad
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Action.startSearch },
                fetchPageProducts
                    .map { Action.fetch($0) }
            )
        
        return action
            .scan([]) { allProducts, action -> [Product] in
                switch action {
                case .startSearch:
                    return []
                case .fetch(let page):
                    return page.info.current == 1 ? page.elements : (allProducts + page.elements)
                }
            }
            .startWith([])
    }
    
    func makePageProducts(
        didStartFirstLoad: Driver<Void>,
        folder: Driver<Folder>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Page<[Product]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, folder: Folder) -> Driver<Page<[Product]>> {
            productsManager
                .obtainProducts(
                    folderId: folder.id,
                    page: page
                )
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = didStartFirstLoad
            .withLatestFrom(folder)
            .flatMapLatest { folder -> Driver<Page<[Product]>> in
                fetch(page: 1, folder: folder)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Product]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(folder)
                    .compactMap { folder -> (Folder, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (folder, lastPageInfo)
                    }
                    .filter { _, lastPageInfo -> Bool in
                        let nextPageNotTotal = lastPageInfo.next <= lastPageInfo.total
                        let currentNotTotal = lastPageInfo.current != lastPageInfo.total
                        return nextPageNotTotal && currentNotTotal
                    }
                    .flatMapFirst { folder, lastPageInfo -> Driver<Page<[Product]>> in
                        fetch(page: lastPageInfo.next, folder: folder)
                    }
                    .startWith(firstPage)
            }
        return downloadedPage
    }
}
