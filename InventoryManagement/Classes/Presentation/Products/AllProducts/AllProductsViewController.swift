//
//  AllProductsViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

final class AllProductsViewController: UIViewController {
    private lazy var mainView = AllProductsView()
    
    private lazy var viewModel = AllProductsViewModel()
    
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
        
        let output = viewModel.configure(input: AllProductsViewModel.Input(
            didScrollToBottom: mainView.tableView.didScrollToBottom,
            didTapMenu: mainView.tableView.didTapMenu,
            didSelectProduct: mainView.tableView.didSelect,
            didTapCreateProduct: mainView.emptyView.addNewButton.rx.tap.asSignal(),
            didDuplicateProduct: didDuplicateProductTrigger.asSignal(),
            didMoveToFolder: didMoveToFolderTrigger.asSignal(),
            didDeleteProduct: didDeleteProductTrigger.asSignal()
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
        case .openDetails(let product):
            CreateProductAssembly().edit(from: self, product: product)
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .createNewProduct:
            CreateProductAssembly().manually(from: self)
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
}
