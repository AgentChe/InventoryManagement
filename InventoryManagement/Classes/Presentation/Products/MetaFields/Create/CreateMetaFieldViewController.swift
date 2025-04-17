//
//  CreateMetaFieldViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit
import RxSwift

final class CreateMetaFieldViewController: UIViewController {
    enum Field {
        case smallTextBox
        case largeTextBox
        case roundNumber
        case decimalNumber
        case checkbox
        case date
        case phoneNumber
        case webLink
        case email
    }
    
    private let mainView: CreateMetaFieldView
    
    private lazy var viewModel = CreateMetaFieldViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private init(field: Field) {
        mainView = CreateMetaFieldView(field: field)
        
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
        
        let output = viewModel.configure(input: CreateMetaFieldViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CreateMetaFieldViewController {
    static func make(field: Field) -> CreateMetaFieldViewController {
        CreateMetaFieldViewController(field: field)
    }
}

// MARK: Private
private extension CreateMetaFieldViewController {
    func action(_ action: CreateMetaFieldViewModel.Action) {
        switch action {
        case .back:
            navigationController?.popViewController(animated: true)
        }
    }
}
