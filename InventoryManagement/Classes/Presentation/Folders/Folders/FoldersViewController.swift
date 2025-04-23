//
//  FoldersViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class FoldersViewController: UIViewController {
    private lazy var mainView = FoldersView()
    
    private lazy var viewModel = FoldersViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: FoldersViewModel.Input(
            didScrollToBottom: mainView.collectionView.didScrollToBottom,
            didSelect: mainView.collectionView.didSelect
        ))
        
        Driver
            .combineLatest(output.isEmpty, output.firstPageActivity)
            .drive(Binder(mainView) { base, args in
                let (isEmpty, isLoading) = args
                
                isLoading ? base.centerPreloader.startAnimating() : base.centerPreloader.stopAnimating()
                
                base.collectionView.isHidden = isLoading || isEmpty
            })
            .disposed(by: disposeBag)
        
        output.paginationActivity
            .drive(Binder(mainView) { base, activity in
                base.collectionView.contentInset.bottom = activity ? 48.scale : 16.scale
                activity ? base.bottomPreloader.startAnimating() : base.bottomPreloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
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
extension FoldersViewController {
    static func make() -> FoldersViewController {
        let vc = FoldersViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Folders.Title".localized
        return vc
    }
}

// MARK: Private
private extension FoldersViewController {
    func action(_ action: FoldersViewModel.Action) {
        switch action {
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .openFolder(let folder):
            let vc = FolderProductsViewController.make(folder: folder)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
