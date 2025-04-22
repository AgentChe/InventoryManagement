//
//  ItemsViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 21.04.2025.
//

import UIKit
import RxSwift

final class ItemsViewController: UIViewController {
    private lazy var mainView = ItemsView()
    
    private lazy var viewModel = ItemsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ItemsViewModel.Input())
        
        output.elements
            .drive(Binder(mainView) { base, elements in
                base.preloader.stopAnimating()
                base.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ItemsViewController {
    static func make() -> ItemsViewController {
        let vc = ItemsViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ItemsViewController {
    
}
