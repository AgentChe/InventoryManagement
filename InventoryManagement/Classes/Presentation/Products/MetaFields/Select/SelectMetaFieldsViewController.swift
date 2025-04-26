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
    
    private let created: (ProductMetaField) -> Void
    
    private init(created: @escaping (ProductMetaField) -> Void) {
        self.created = created
        
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
    static func make(created: @escaping (ProductMetaField) -> Void) -> NavigationController {
        let vc =  SelectMetaFieldsViewController(created: created)
        let nc = NavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        return nc
    }
}

// MARK: Private
private extension SelectMetaFieldsViewController {
    func action(_ action: SelectMetaFieldsViewModel.Action) {
        switch action {
        case .createField(let field):
            let vc = CreateMetaFieldViewController.make(field: field, created: { [weak self] field in
                self?.navigationController?.dismiss(animated: true) { [weak self] in
                    self?.created(field)
                }
            })
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
