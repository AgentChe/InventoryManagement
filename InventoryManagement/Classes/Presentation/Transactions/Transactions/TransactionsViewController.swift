//
//  TransactionsViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 27.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class TransactionsViewController: UIViewController {
    private lazy var mainView = TransactionsView()
    
    private lazy var viewModel = TransactionsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectFiltersTrigger = PublishRelay<TransactionsFiltersViewController.SelectedFilters>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: TransactionsViewModel.Input(
            didTapFilters: mainView.filtersButton.rx.tap.asSignal(),
            didSelectFilters: didSelectFiltersTrigger.asSignal(),
            didScrollToBottom: mainView.tableView.didScrollToBottom,
            didTapDeleteFilterType: mainView.filtersCollectionView.didTapDeleteFilterType
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.hasSelectedFilters
            .drive(Binder(mainView) { base, hasSelectedFilters in
                base.setup(hasSelectedFilters: hasSelectedFilters)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(output.isEmpty, output.firstPageActivity)
            .drive(Binder(mainView) { base, args in
                let (isEmpty, isLoading) = args
                
                isLoading ? base.centerPreloader.startAnimating() : base.centerPreloader.stopAnimating()
                
                base.tableView.isHidden = isLoading || isEmpty
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(mainView) { base, activity in
                base.tableView.contentInset.bottom = activity ? 48.scale : 16.scale
                activity ? base.bottomPreloader.startAnimating() : base.bottomPreloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.selectedFiltersElements
            .drive(Binder(mainView.filtersCollectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension TransactionsViewController {
    static func make() -> TransactionsViewController {
        let vc = TransactionsViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension TransactionsViewController {
    func action(_ action: TransactionsViewModel.Action) {
        switch action {
        case .openFilters(let filters):
            let vc = TransactionsFiltersViewController.make(selected: filters) { [weak self] filters in
                self?.didSelectFiltersTrigger.accept(filters)
            }
            present(vc, animated: true)
        }
    }
}
