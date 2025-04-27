//
//  TransactionsFiltersViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 27.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class TransactionsFiltersViewController: UIViewController {
    struct SelectedFilters {
        let types: [String]
        let sort: String
    }
    
    private lazy var mainView = TransactionsFiltersView()
    
    private let viewModel: TransactionsFiltersViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectSortTrigger = PublishRelay<String>()
    
    private let confirm: (SelectedFilters) -> Void
    
    private init(selected: SelectedFilters, confirm: @escaping (SelectedFilters) -> Void) {
        self.viewModel = TransactionsFiltersViewModel(selected: selected)
        self.confirm = confirm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: TransactionsFiltersViewModel.Input(
            didTapSort: mainView.collectionView.didTapSort,
            didSelectSort: didSelectSortTrigger.asSignal(),
            didTapSave: mainView.saveButton.rx.tap.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension TransactionsFiltersViewController {
    static func make(selected: SelectedFilters, confirm: @escaping (SelectedFilters) -> Void) -> TransactionsFiltersViewController {
        TransactionsFiltersViewController(selected: selected, confirm: confirm)
    }
}

// MARK: Private
private extension TransactionsFiltersViewController {
    func action(_ action: TransactionsFiltersViewModel.Action) {
        switch action {
        case .selectSort(let values):
            selectSort(values: values)
        case .confirm(let filters):
            dismiss(animated: true) { [weak self] in
                self?.confirm(filters)
            }
        }
    }
    
    func selectSort(values: [String]) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        values.forEach { value in
            let action = UIAlertAction(title: value, style: .default) { [weak self] action in
                self?.didSelectSortTrigger.accept(value)
            }
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}
