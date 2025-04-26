//
//  ItemsViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 21.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

final class ItemsViewController: UIViewController {
    private lazy var mainView = ItemsView()
    
    private lazy var viewModel = ItemsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didDuplicateProductTrigger = PublishRelay<Product>()
    private lazy var didMoveToFolderTrigger = PublishRelay<(Product, Folder)>()
    private lazy var didDeleteProductTrigger = PublishRelay<Product>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: ItemsViewModel.Input(
            didTapAddFirstItem: mainView.tableView.didTapAddFirstItem,
            didTapUnlockAccess: mainView.tableView.didTapUnlockAccess,
            didSelectDemoProduct: mainView.tableView.didSelectDemoProduct,
            didSelectFolder: mainView.tableView.didSelectFolder,
            didTapAddNewFolder: mainView.tableView.didTapAddNewFolder,
            didSelectProduct: mainView.tableView.didSelectProduct,
            didTapProductMenu: mainView.tableView.didTapProductMenu,
            didTapSeeAllBlock: mainView.tableView.didTapSeeAllBlock,
            didDuplicateProduct: didDuplicateProductTrigger.asSignal(),
            didMoveToFolder: didMoveToFolderTrigger.asSignal(),
            didDeleteProduct: didDeleteProductTrigger.asSignal()
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
            selectMethodCreateProduct()
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
            let menu = ProductMenuActionSheet().actionSheet(
                product: product,
                duplicate: { [weak self] product in
                    self?.didDuplicateProductTrigger.accept(product)
                },
                moveToFolder: { [weak self] product in
                    guard let self else { return }
                    
                    let vc = WhereMoveFoldersViewController.make { [weak self] folder in
                        self?.didMoveToFolderTrigger.accept((product, folder))
                    }
                    present(vc, animated: true)
                },
                delete: { [weak self] product in
                    self?.didDeleteProductTrigger.accept(product)
                }
            )
            
            present(menu, animated: true)
        case .openFolders:
            let vc = FoldersViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .openAllProducts:
            let vc = AllProductsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .toast(let message):
            mainView.makeToast(message)
        }
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self else { return Disposables.create() }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func selectMethodCreateProduct() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let scanBarcodeAction = UIAlertAction(title: "Items.ScanBarcode".localized, style: .default) { [weak self] action in
            guard let self else { return }
            
            CreateProductAssembly().scan(from: self)
        }
        actionSheet.addAction(scanBarcodeAction)
        
        let addManuallyAction = UIAlertAction(title: "Items.AddManually".localized, style: .default) { [weak self] action in
            guard let self else { return }
            
            CreateProductAssembly().manually(from: self)
        }
        actionSheet.addAction(addManuallyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}
