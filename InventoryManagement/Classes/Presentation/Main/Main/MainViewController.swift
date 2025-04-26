//
//  MainViewController.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 28.01.2025.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    
    private lazy var coordinator = MainCoordinator(
        parentVC: self,
        container: mainView.container
    )
    
    private lazy var disposeBag = DisposeBag()
    
    private let requestReview: Bool
    
    private init(requestReview: Bool) {
        self.requestReview = requestReview

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
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.coordinator.change(tab: .items)
                base.mainView.tabView.selectedTab = .items
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.tabView.itemsButton
                    .rx.tap.map { TabView.Tab.items },
                mainView.tabView.transactionsButton
                    .rx.tap.map { TabView.Tab.transactions },
                mainView.tabView.searchButton
                    .rx.tap.map { TabView.Tab.search },
                mainView.tabView.settingsButton
                    .rx.tap.map { TabView.Tab.settings }
            ])
            .bind(to: Binder(self) { base, tab in
                base.coordinator.change(tab: tab)
                base.mainView.tabView.selectedTab = tab
            })
            .disposed(by: disposeBag)
        
        mainView.tabView.addButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.openAddActionSheet()
            })
            .disposed(by: disposeBag)
        
        if requestReview {
            RequestReview.request()
        }
    }
}

// MARK: Public
extension MainViewController {
    static func make(requestReview: Bool) -> NavigationController {
        let vc = MainViewController(requestReview: requestReview)
        vc.navigationItem.backButtonTitle = " "
        return NavigationController(rootViewController: vc)
    }
}

// MARK: Private
private extension MainViewController {
    func openAddActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let scanBarcodeAction = UIAlertAction(title: "Main.ScanBarcode".localized, style: .default) { [weak self] action in
            guard let self else { return }
            
            CreateProductAssembly().scan(from: self)
        }
        actionSheet.addAction(scanBarcodeAction)
        
        let addManuallyAction = UIAlertAction(title: "Main.AddManually".localized, style: .default) { [weak self] action in
            guard let self else { return }
            
            CreateProductAssembly().manually(from: self)
        }
        actionSheet.addAction(addManuallyAction)
        
        let addFolderAction = UIAlertAction(title: "Main.AddFolder".localized, style: .default) { [weak self] action in
            let vc = CreateFolderViewController.create()
            self?.present(vc, animated: false)
        }
        actionSheet.addAction(addFolderAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}
