//
//  WhereMoveFoldersViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 24.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class WhereMoveFoldersViewController: UIViewController {
    private lazy var mainView = WhereMoveFoldersView()
    
    private lazy var viewModel = WhereMoveFoldersViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let selected: (Folder) -> Void
    
    private init(selected: @escaping (Folder) -> Void) {
        self.selected = selected
        
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
        
        let output = viewModel.configure(input: WhereMoveFoldersViewModel.Input(
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
extension WhereMoveFoldersViewController {
    static func make(selected: @escaping (Folder) -> Void) -> NavigationController {
        let vc = WhereMoveFoldersViewController(selected: selected)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WhereMoveFolders.Title".localized
        
        return NavigationController(rootViewController: vc)
    }
}

// MARK: Private
private extension WhereMoveFoldersViewController {
    func action(_ action: WhereMoveFoldersViewModel.Action) {
        switch action {
        case .selected(let folder):
            navigationController?.dismiss(animated: true) { [weak self] in
                self?.selected(folder)
            }
        }
    }
}
