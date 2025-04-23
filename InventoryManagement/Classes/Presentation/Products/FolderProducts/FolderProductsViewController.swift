//
//  FolderProductsViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class FolderProductsViewController: UIViewController {
    private lazy var mainView = FolderProductsView()
    
    private let viewModel: FolderProductsViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var menuButton = TapAreaButton()
    
    private lazy var didTapDeleteTrigger = PublishRelay<Void>()
    private lazy var didDeleteConfirmedTrigger = PublishRelay<Void>()
    private lazy var didTapRenameTrigger = PublishRelay<Void>()
    
    private init(folder: Folder) {
        viewModel = FolderProductsViewModel(folder: folder)
        
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
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: FolderProductsViewModel.Input(
            didScrollToBottom: mainView.tableView.didScrollToBottom,
            didTapProductMenu: mainView.tableView.didTapMenu,
            didSelectProduct: mainView.tableView.didSelect,
            didTapCreateProduct: mainView.emptyView.addNewButton.rx.tap.asSignal(),
            didTapMenu: menuButton.rx.tap.asSignal(),
            didTapDeleteFolder: didTapDeleteTrigger.asSignal(),
            didTapRenameFolder: didTapRenameTrigger.asSignal(),
            didDeleteConfirmed: didDeleteConfirmedTrigger.asSignal()
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
        
        output.title
            .drive(Binder(navigationItem) { base, title in
                base.title = title
            })
            .disposed(by: disposeBag)
        
        addMenuButton()
    }
}

// MARK: Public
extension FolderProductsViewController {
    static func make(folder: Folder) -> FolderProductsViewController {
        let vc = FolderProductsViewController(folder: folder)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = folder.title
        return vc
    }
}

// MARK: Private
private extension FolderProductsViewController {
    func action(_ action: FolderProductsViewModel.Action) {
        switch action {
        case .openProductMenu(let product):
            print("open menu") // TODO
        case .openDetails(let product):
            CreateProductAssembly().edit(from: self, product: product)
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .createNewProduct:
            CreateProductAssembly().manually(from: self)
        case .openMenu:
            openMenu()
        case .close:
            navigationController?.popViewController(animated: true)
        case .confirmDelete(let folder):
            confirmDelete(folder: folder)
        }
    }
    
    func openMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(
            title: "FolderProducts.Menu.Delete".localized,
            style: .default
        ) { [weak self] action in
            self?.didTapDeleteTrigger.accept(Void())
        }
        alert.addAction(deleteAction)
        
        let renameAction = UIAlertAction(
            title: "FolderProducts.Menu.Rename".localized,
            style: .default
        ) { [weak self] action in
            self?.didTapRenameTrigger.accept(Void())
        }
        alert.addAction(renameAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func confirmDelete(folder: Folder) {
        let text = String(format: "FolderProducts.ConfirmDelete.Text".localized, folder.title)
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive) { [weak self] action in
            self?.didDeleteConfirmedTrigger.accept(Void())
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func addMenuButton() {
        menuButton.backgroundColor = UIColor.clear
        menuButton.setImage(UIImage(named: "Folders.Menu"), for: .normal)
        
        let item = UIBarButtonItem(customView: menuButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
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
