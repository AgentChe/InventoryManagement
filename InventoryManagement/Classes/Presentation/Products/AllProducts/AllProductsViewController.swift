//
//  AllProductsViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class AllProductsViewController: UIViewController {
    private lazy var mainView = AllProductsView()
    
    private lazy var viewModel = AllProductsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: AllProductsViewModel.Input(
            didScrollToBottom: mainView.tableView.didScrollToBottom,
            didTapMenu: mainView.tableView.didTapMenu,
            didSelectProduct: mainView.tableView.didSelect,
            didTapCreateProduct: mainView.emptyView.addNewButton.rx.tap.asSignal()
        ))
        
        Driver
            .combineLatest(output.isEmpty, output.firstPageActivity)
            .drive(Binder(mainView) { base, args in
                let (isEmpty, isLoading) = args
                
                isLoading ? base.centerPreloader.startAnimating() : base.centerPreloader.stopAnimating()
                
                base.emptyView.isHidden = isLoading || !isEmpty
                base.tableView.isHidden = isLoading || isEmpty
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(mainView) { base, activity in
                base.tableView.contentInset.bottom = activity ? 48.scale : 8.scale
                activity ? base.bottomPreloader.startAnimating() : base.bottomPreloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
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
extension AllProductsViewController {
    static func make() -> AllProductsViewController {
        let vc = AllProductsViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "AllProducts.Title".localized
        return vc
    }
}

// MARK: Private
private extension AllProductsViewController {
    func action(_ action: AllProductsViewModel.Action) {
        switch action {
        case .openMenu(let product):
            print("open menu") // TODO
        case .openDetails(let product):
            CreateProductAssembly().edit(from: self, product: product)
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .createNewProduct:
            CreateProductAssembly().manually(from: self)
        }
    }
}
