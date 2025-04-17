//
//  SelectMetaFieldsViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit
import RxSwift

final class SelectMetaFieldsViewController: UIViewController {
    private lazy var mainView = SelectMetaFieldsView()
    
    private lazy var viewModel = SelectMetaFieldsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SelectMetaFieldsViewModel.Input(
            didSelect: mainView.tableView.didSelect
        ))
        
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
extension SelectMetaFieldsViewController {
    static func make() -> NavigationController {
        let nc = NavigationController(rootViewController: SelectMetaFieldsViewController())
        nc.setNavigationBarHidden(true, animated: false)
        return nc
    }
}

// MARK: Private
private extension SelectMetaFieldsViewController {
    func action(_ action: SelectMetaFieldsViewModel.Action) {
        switch action {
        case .createField(let field):
            let vc = CreateMetaFieldViewController.make(field: field)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
