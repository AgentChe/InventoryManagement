//
//  TransactionsViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 27.04.2025.
//

import RxSwift
import RxCocoa

final class TransactionsViewModel {
    enum Action {
        case openFilters(TransactionsFiltersViewController.SelectedFilters)
    }
    
    private lazy var firstPageActivity = RxActivityIndicator()
    private lazy var paginationActivity = RxActivityIndicator()
    
    private lazy var transactionsManager = TransactionsManager()
}

// MARK: Public
extension TransactionsViewModel {
    struct Input {
        let didTapFilters: Signal<Void>
        let didSelectFilters: Signal<TransactionsFiltersViewController.SelectedFilters>
        let didScrollToBottom: Signal<Void>
        let didTapDeleteFilterType: Signal<String>
    }
    
    struct Output {
        let action: Driver<Action>
        let hasSelectedFilters: Driver<Bool>
        let firstPageActivity: Driver<Bool>
        let paginationActivity: Driver<Bool>
        let isEmpty: Driver<Bool>
        let elements: Driver<[TransactionItem]>
        let selectedFiltersElements: Driver<[String]>
    }
    
    func configure(input: Input) -> Output {
        let filters = makeFilters(
            didSelectFilters: input.didSelectFilters,
            didTapDeleteFilterType: input.didTapDeleteFilterType
        )
        let allItems = makeAllItems(
            startSearch: filters,
            fetchPageProducts: makePageItems(
                startSearch: filters,
                didScrollToBottom: input.didScrollToBottom
            )
        )
        
        return Output(
            action: makeAction(
                didTapFilters: input.didTapFilters,
                filters: filters
            ),
            hasSelectedFilters: filters.map { !$0.types.isEmpty },
            firstPageActivity: firstPageActivity.asDriver(),
            paginationActivity: paginationActivity.asDriver(),
            isEmpty: allItems.map { $0.isEmpty },
            elements: allItems,
            selectedFiltersElements: filters.map { $0.types }
        )
    }
}

// MARK: Private
private extension TransactionsViewModel {
    func makeAction(
        didTapFilters: Signal<Void>,
        filters: Driver<TransactionsFiltersViewController.SelectedFilters>
    ) -> Driver<Action> {
        didTapFilters
            .withLatestFrom(filters)
            .map { Action.openFilters($0) }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeAllItems(
        startSearch: Driver<TransactionsFiltersViewController.SelectedFilters>,
        fetchPageProducts: Driver<Page<[TransactionItem]>>
    ) -> Driver<[TransactionItem]> {
        enum Action {
            case startSearch
            case fetch(Page<[TransactionItem]>)
        }
        
        let action = Driver
            .merge(
                startSearch
                    .map { _ in Action.startSearch },
                fetchPageProducts
                    .map { Action.fetch($0) }
            )
        
        return action
            .scan([]) { allItems, action -> [TransactionItem] in
                switch action {
                case .startSearch:
                    return []
                case .fetch(let page):
                    return page.info.current == 1 ? page.elements : (allItems + page.elements)
                }
            }
            .startWith([])
    }
    
    func makePageItems(
        startSearch: Driver<TransactionsFiltersViewController.SelectedFilters>,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Page<[TransactionItem]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(page: Int, filters: TransactionsFiltersViewController.SelectedFilters) -> Driver<Page<[TransactionItem]>> {
            transactionsManager
                .obtainItems(
                    filters: filters.types,
                    sort: filters.sort,
                    foldersIds: nil,
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
            .flatMapLatest { filters -> Driver<Page<[TransactionItem]>> in
                fetch(page: 1, filters: filters)
            }
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[TransactionItem]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(startSearch)
                    .compactMap { filters -> (TransactionsFiltersViewController.SelectedFilters, PageInfo)? in
                        guard let lastPageInfo else { return nil }
                        return (filters, lastPageInfo)
                    }
                    .filter { _, lastPageInfo -> Bool in
                        let nextPageNotTotal = lastPageInfo.next <= lastPageInfo.total
                        let currentNotTotal = lastPageInfo.current != lastPageInfo.total
                        return nextPageNotTotal && currentNotTotal
                    }
                    .flatMapFirst { filters, lastPageInfo -> Driver<Page<[TransactionItem]>> in
                        fetch(page: lastPageInfo.next, filters: filters)
                    }
                    .startWith(firstPage)
            }
        return downloadedPage
    }
    
    func makeFilters(
        didSelectFilters: Signal<TransactionsFiltersViewController.SelectedFilters>,
        didTapDeleteFilterType: Signal<String>
    ) -> Driver<TransactionsFiltersViewController.SelectedFilters> {
        let initial = transactionsManager
            .obtainFilters(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
            .map { filters -> TransactionsFiltersViewController.SelectedFilters in
                TransactionsFiltersViewController.SelectedFilters(
                    types: [],
                    sort: filters?.sort.first ?? ""
                )
            }
        
        return initial
            .flatMapLatest { initial -> Driver<TransactionsFiltersViewController.SelectedFilters> in
                enum Action {
                    case select(TransactionsFiltersViewController.SelectedFilters)
                    case delete(String)
                }
                
                let action = Signal
                    .merge(
                        didSelectFilters.map { Action.select($0) },
                        didTapDeleteFilterType.map { Action.delete($0) }
                    )
                
                return action
                    .scan(initial) { current, action -> TransactionsFiltersViewController.SelectedFilters in
                        switch action {
                        case .select(let filters):
                            return filters
                        case .delete(let type):
                            var types = current.types
                            types.removeAll(where: { $0 == type })
                            
                            return TransactionsFiltersViewController.SelectedFilters(
                                types: types, sort: current.sort
                            )
                        }
                    }
                    .startWith(initial)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
