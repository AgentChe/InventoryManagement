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
            didSelectFilters: didSelectFiltersTrigger.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
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
