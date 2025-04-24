//
//  DemoProductViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit
import RxSwift

final class DemoProductViewController: UIViewController {
    private lazy var mainView = DemoProductView()
    
    private let viewModel: DemoProductViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private init(demoProduct: DemoProduct.Product) {
        viewModel = DemoProductViewModel(demoProduct: demoProduct)
        
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
        
        let output = viewModel.configure(input: DemoProductViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        addCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyNavigationSettings(appear: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        applyNavigationSettings(appear: false)
    }
}

// MARK: Public
extension DemoProductViewController {
    static func make(demoProduct: DemoProduct.Product) -> NavigationController {
        let vc = DemoProductViewController(demoProduct: demoProduct)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = {
            switch demoProduct {
            case .stanleyCup:
                return "DemoProduct.SP.Title".localized
            case .vitaminC:
                return "DemoProduct.VitaminC.Title".localized
            }
        }()
        let nc = NavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        return nc
    }
}

// MARK: Private
private extension DemoProductViewController {
    func action(_ action: DemoProductViewModel.Action) {
        switch action {
        case .close:
            navigationController?.dismiss(animated: true)
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.White"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.leftBarButtonItem = item
    }
    
    func applyNavigationSettings(appear: Bool) {
        guard let nc = navigationController as? NavigationController else { return  }
        
        let appearSettings = NavigationControllerSettings(
            backgroundImage: UIImage(),
            shadowImage: UIImage(),
            isTranslucent: true,
            tintColor: Appearance.mono100,
            titleTextAttrributes: TextAttributes()
                .textColor(Appearance.mono100)
                .font(Fonts.SFPro.bold(size: 17.scale))
                .textAlignment(.center)
                .dictionary
        )
        
        let disappearSettings = NavigationControllerSettings.default()
        
        let settings = appear ? appearSettings : disappearSettings
        
        nc.apply(settings: settings)
    }
}
