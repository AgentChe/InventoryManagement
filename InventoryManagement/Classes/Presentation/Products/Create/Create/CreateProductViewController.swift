//
//  CreateProductViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 11.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateProductViewController: UIViewController {
    enum Source {
        case scan(Barcode)
        case manually
        case edit(Product)
    }
    
    private lazy var mainView = CreateProductView()
    
    private let viewModel: CreateProductViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var didAddedNewPhotoTrigger = PublishRelay<UIImage>()
    private lazy var didCreateNewBarcodeTrigger = PublishRelay<Barcode>()
    private lazy var didCreatedNewFieldTrigger = PublishRelay<ProductMetaField>()
    
    private var takePhoto: TakePhoto?
    
    private init(source: Source) {
        self.viewModel = CreateProductViewModel(source: source)
        
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
        
        mainView.tableView.vc = self
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        mainView.tableView
            .rx.willBeginDragging
            .bind(to: mainView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: CreateProductViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didSelectPhoto: mainView.tableView.didSelectPhoto,
            didDeletePhoto: mainView.tableView.didDeletePhoto,
            didTapAddNewPhoto: mainView.tableView.didTapAddPhoto,
            didAddedNewPhoto: didAddedNewPhotoTrigger.asSignal(),
            didChangedTitle: mainView.tableView.changedTitle,
            didChangedCount: mainView.tableView.changedCount,
            didChangedPriceValue: mainView.tableView.changedPrice,
            didChangedPriceCurrency: mainView.tableView.changedPriceCurrency,
            didTapAddFields: mainView.tableView.didTapAddFields,
            didTapAddBarcode: mainView.tableView.didTapAddBarcode,
            didCreateNewBarcode: didCreateNewBarcodeTrigger.asSignal(),
            didTapSave: mainView.tableView.didTapSave,
            didCreatedNewField: didCreatedNewFieldTrigger.asSignal()
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
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        addCloseButton()
    }
}

// MARK: Public
extension CreateProductViewController {
    static func make(source: Source) -> CreateProductViewController {
        let vc = CreateProductViewController(source: source)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = {
            switch source {
            case .scan, .manually:
                return "CreateProduct.Title".localized
            case .edit(let product):
                return product.title
            }
        }()
        return vc
    }
}

// MARK: Private
private extension CreateProductViewController {
    func action(_ action: CreateProductViewModel.Action) {
        switch action {
        case .close:
            navigationController?.dismiss(animated: true)
        case .addPhoto:
            takePhoto = TakePhoto { [weak self] image in
                self?.didAddedNewPhotoTrigger.accept(image)
            }
            takePhoto?.take(from: self)
        case .addFields:
            let vc = SelectMetaFieldsViewController.make { [weak self] field in
                self?.didCreatedNewFieldTrigger.accept(field)
            }
            present(vc, animated: true)
        case .addBarcode:
            let nc = NavigationController()
            nc.modalPresentationStyle = .fullScreen
            
            let vc = ScannerViewController.make { [weak nc] barcode in
                nc?.dismiss(animated: true) { [weak self] in
                    self?.didCreateNewBarcodeTrigger.accept(barcode)
                }
            }
            nc.setViewControllers([vc], animated: false)
            
            present(nc, animated: true)
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.Black"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.leftBarButtonItem = item
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
