//
//  WhereMoveFoldersViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 24.04.2025.
//

import RxSwift
import RxCocoa

final class WhereMoveFoldersViewModel {
    enum Action {
        case selected(Folder)
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var foldersManager = FoldersManager()
}

// MARK: Public
extension WhereMoveFoldersViewModel {
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
        let fetchPageFolders = makePageFolders(didScrollToBottom: input.didScrollToBottom)
        let allFolders = makeAllFolders(fetchPageFolders: fetchPageFolders)
        
        return Output(
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver(),
            elements: allFolders,
            action: makeAction(didSelect: input.didSelect),
            isEmpty: allFolders.map { $0.isEmpty }
        )
    }
}

// MARK: Private
private extension WhereMoveFoldersViewModel {
    func makeAction(didSelect: Signal<Folder>) -> Driver<Action> {
        didSelect
            .map { Action.selected($0) }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeAllFolders(fetchPageFolders: Driver<Page<[Folder]>>) -> Driver<[Folder]> {
        fetchPageFolders
            .scan([]) { allFolders, page -> [Folder] in
                allFolders + page.elements
            }
    }
    
    func makePageFolders(didScrollToBottom: Signal<Void>) -> Driver<Page<[Folder]>> {
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
        
        let firstPage = fetch(page: 1)
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
