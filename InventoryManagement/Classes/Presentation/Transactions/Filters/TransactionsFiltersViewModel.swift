//
//  TransactionsFiltersViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 27.04.2025.
//

import RxSwift
import RxCocoa

final class TransactionsFiltersViewModel {
    enum Action {
        case selectSort([String])
        case confirm(TransactionsFiltersViewController.SelectedFilters)
    }
    
    private let initialFilters: Driver<TransactionsFiltersViewController.SelectedFilters>
    
    private lazy var transactionsManager = TransactionsManager()
    
    init(selected: TransactionsFiltersViewController.SelectedFilters) {
        initialFilters = BehaviorRelay(value: selected).asDriver()
    }
}

// MARK: Public
extension TransactionsFiltersViewModel {
    struct Input {
        let didTapSort: Signal<Void>
        let didSelectSort: Signal<String>
        let didTapSave: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[TransactionsFiltersCollectionElement]>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let filters = makeFilters()
        let selectedSort = makeSelectedSort(
            initialFilters: initialFilters,
            didSelectSort: input.didSelectSort
        )
        let typesElements = makeTypesElements(
            initialFilters: initialFilters,
            filters: filters
        )
        
        return Output(
            elements: makeElements(
                selectedSort: selectedSort,
                typesElements: typesElements
            ),
            action: makeAction(
                didTapSort: input.didTapSort,
                filters: filters,
                didTapSave: input.didTapSave,
                selectedSort: selectedSort,
                typesElements: typesElements
            )
        )
    }
}

// MARK: Private
private extension TransactionsFiltersViewModel {
    func makeElements(
        selectedSort: Driver<String>,
        typesElements: Driver<[TransactionsFiltersTypeElement]>
    ) -> Driver<[TransactionsFiltersCollectionElement]> {
        Driver
            .combineLatest(selectedSort, typesElements)
            .map { selectedSort, typesElements -> [TransactionsFiltersCollectionElement] in
                var elements = [TransactionsFiltersCollectionElement]()
                elements.append(.transactionTypesTitle)
                elements.append(contentsOf: typesElements.map { TransactionsFiltersCollectionElement.transactionType($0) })
                elements.append(.sort(selectedSort))
                return elements
            }
    }
    
    func makeTypesElements(
        initialFilters: Driver<TransactionsFiltersViewController.SelectedFilters>,
        filters: Driver<TransactionsFilters>
    ) -> Driver<[TransactionsFiltersTypeElement]> {
        Driver
            .combineLatest(initialFilters, filters)
            .map { initialFilters, filters -> [TransactionsFiltersTypeElement] in
                filters.filters.map { type -> TransactionsFiltersTypeElement in
                    TransactionsFiltersTypeElement(
                        type: type,
                        selected: initialFilters.types.contains(type)
                    )
                }
            }
    }
    
    func makeSelectedSort(
        initialFilters: Driver<TransactionsFiltersViewController.SelectedFilters>,
        didSelectSort: Signal<String>
    ) -> Driver<String> {
        Driver<String>
            .merge(
                initialFilters.map { $0.sort },
                didSelectSort.asDriver(onErrorDriveWith: .never())
            )
    }
    
    func makeAction(
        didTapSort: Signal<Void>,
        filters: Driver<TransactionsFilters>,
        didTapSave: Signal<Void>,
        selectedSort: Driver<String>,
        typesElements: Driver<[TransactionsFiltersTypeElement]>
    ) -> Driver<Action> {
        let sort = didTapSort
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(filters)
            .map { Action.selectSort($0.sort) }
        
        let save = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(selectedSort)
            .withLatestFrom(typesElements) { ($0, $1) }
            .map { selectedSort, typesElements -> TransactionsFiltersViewController.SelectedFilters in
                TransactionsFiltersViewController.SelectedFilters(
                    types: typesElements.compactMap { $0.selected ? $0.type : nil },
                    sort: selectedSort
                )
            }
            .map { Action.confirm($0) }
        
        return Driver
            .merge(sort, save)
    }
    
    func makeFilters() -> Driver<TransactionsFilters> {
        transactionsManager
            .obtainFilters(forceUpdate: false)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
    }
}
