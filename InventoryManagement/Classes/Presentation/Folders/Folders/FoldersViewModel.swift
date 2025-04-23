//
//  FoldersViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import RxSwift
import RxCocoa

final class FoldersViewModel {
    enum Action {
        case openPaygate
        case openFolder(Folder)
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var foldersManager = FoldersManager()
}

// MARK: Public
extension FoldersViewModel {
    struct Input {
        let didScrollToBottom: Signal<Void>
        let didSelect: Signal<Folder>
    }
    
    struct Output {
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let elements: Driver<[Folder]>
        let action: Driver<Action>
        let isEmpty: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let didStartFirstLoad = FoldersMediator.shared.didCreated
            .map { _ in Void() }
            .asDriver(onErrorDriveWith: .never())
            .startWith(())
        let fetchPageFolders = makePageFolders(
            didStartFirstLoad: didStartFirstLoad,
            didScrollToBottom: input.didScrollToBottom
        )
        let allFolders = makeAllFolders(
            didStartFirstLoad: didStartFirstLoad,
            fetchPageFolders: fetchPageFolders
        )
        let firstPageActivity = firstPageActivity.asDriver()
        
        return Output(
            firstPageActivity: firstPageActivity,
            paginationActivity: paginationActivity.asDriver(),
            elements: allFolders,
            action: makeAction(didSelect: input.didSelect),
            isEmpty: allFolders.map { $0.isEmpty }
        )
    }
}

// MARK: Private
private extension FoldersViewModel {
    func makeAction(didSelect: Signal<Folder>) -> Driver<Action> {
        let openFolder = didSelect
            .map { SessionManager().hasActiveSubscriptions() ? Action.openFolder($0) : Action.openPaygate }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openFolder)
    }
    
    func makeAllFolders(
        didStartFirstLoad: Driver<Void>,
        fetchPageFolders: Driver<Page<[Folder]>>
    ) -> Driver<[Folder]> {
        enum Action {
            case startSearch
            case fetch(Page<[Folder]>)
            case delete(String)
        }
        
        let action = Driver
            .merge(
                didStartFirstLoad
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Action.startSearch },
                fetchPageFolders
                    .map { Action.fetch($0) },
                FoldersMediator.shared.didDeleted
                    .asDriver(onErrorDriveWith: .never())
                    .map { Action.delete($0) }
            )
        
        return action
            .scan([]) { allFolders, action -> [Folder] in
                switch action {
                case .startSearch:
                    return []
                case .fetch(let page):
                    return page.info.current == 1 ? page.elements : (allFolders + page.elements)
                case .delete(let id):
                    var result = allFolders
                    result.removeAll(where: { $0.id == id })
                    return result
                }
            }
            .startWith([])
    }
    
    func makePageFolders(
        didStartFirstLoad: Driver<Void>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Page<[Folder]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int) -> Driver<Page<[Folder]>> {
            foldersManager
                .obtain(page: page)
                .trackActivity(page == 1 ? firstPageActivity : paginationActivity)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = didStartFirstLoad
            .flatMapLatest { void -> Driver<Page<[Folder]>> in
                fetch(page: 1)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Folder]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .compactMap { lastPageInfo }
                    .filter { lastPageInfo -> Bool in
                        let nextPageNotTotal = lastPageInfo.next <= lastPageInfo.total
                        let currentNotTotal = lastPageInfo.current != lastPageInfo.total
                        return nextPageNotTotal && currentNotTotal
                    }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[Folder]>> in
                        fetch(page: lastPageInfo.next)
                    }
                    .startWith(firstPage)
            }
        return downloadedPage
    }
}
