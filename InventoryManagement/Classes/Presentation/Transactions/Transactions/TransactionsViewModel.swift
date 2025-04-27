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
    
    private lazy var transactionsManager = TransactionsManager()
}

// MARK: Public
extension TransactionsViewModel {
    struct Input {
        let didTapFilters: Signal<Void>
        let didSelectFilters: Signal<TransactionsFiltersViewController.SelectedFilters>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let filters = makeFilters(didSelectFilters: input.didSelectFilters)
        
        return Output(
            action: makeAction(
                didTapFilters: input.didTapFilters,
                filters: filters
            )
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
    
    func makeFilters(didSelectFilters: Signal<TransactionsFiltersViewController.SelectedFilters>) -> Driver<TransactionsFiltersViewController.SelectedFilters> {
        let initial = transactionsManager
            .obtainFilters(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
            .map { filters -> TransactionsFiltersViewController.SelectedFilters in
                TransactionsFiltersViewController.SelectedFilters(
                    types: [],
                    sort: filters?.sort.first ?? ""
                )
            }
        
        let selected = didSelectFilters.asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(initial, selected)
    }
}
