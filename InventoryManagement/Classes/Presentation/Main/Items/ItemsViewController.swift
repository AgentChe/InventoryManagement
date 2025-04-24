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
        
        let output = viewModel.configure(input: ItemsViewModel.Input(
            didTapAddFirstItem: mainView.tableView.didTapAddFirstItem,
            didTapUnlockAccess: mainView.tableView.didTapUnlockAccess,
            didSelectDemoProduct: mainView.tableView.didSelectDemoProduct,
            didSelectFolder: mainView.tableView.didSelectFolder,
            didTapAddNewFolder: mainView.tableView.didTapAddNewFolder,
            didSelectProduct: mainView.tableView.didSelectProduct,
            didTapProductMenu: mainView.tableView.didTapProductMenu,
            didTapSeeAllBlock: mainView.tableView.didTapSeeAllBlock
        ))
        
        output.elements
            .drive(Binder(mainView) { base, elements in
                base.preloader.stopAnimating()
                base.tableView.setup(elements: elements)
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
extension ItemsViewController {
    static func make() -> ItemsViewController {
        let vc = ItemsViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ItemsViewController {
    func action(_ action: ItemsViewModel.Action) {
        switch action {
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .createProduct:
            break // TODO
        case .openDemoProduct(let demoProduct):
            let vc = DemoProductViewController.make(demoProduct: demoProduct.product)
            present(vc, animated: true)
        case .openFolder(let folder):
            let vc = FolderProductsViewController.make(folder: folder)
            navigationController?.pushViewController(vc, animated: true)
        case .createFolder:
            let vc = CreateFolderViewController.create()
            present(vc, animated: false)
        case .openProduct(let product):
            CreateProductAssembly().edit(from: self, product: product)
        case .openProductMenu(let product):
            break // TODO
        case .openFolders:
            let vc = FoldersViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .openAllProducts:
            let vc = AllProductsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
