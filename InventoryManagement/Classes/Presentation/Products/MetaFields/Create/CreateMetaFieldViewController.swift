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
    
    private let created: (ProductMetaField) -> Void
    
    private init(field: Field, created: @escaping (ProductMetaField) -> Void) {
        self.mainView = CreateMetaFieldView(field: field)
        self.created = created
        
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
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didTapCreate: mainView.saveButton.rx.tap.asSignal()
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
    static func make(field: Field, created: @escaping (ProductMetaField) -> Void) -> CreateMetaFieldViewController {
        CreateMetaFieldViewController(field: field, created: created)
    }
}

// MARK: Private
private extension CreateMetaFieldViewController {
    func action(_ action: CreateMetaFieldViewModel.Action) {
        switch action {
        case .back:
            navigationController?.popViewController(animated: true)
        case .createField:
            let field = mainView.createView.createField()
            created(field)
            
            navigationController?.popViewController(animated: true)
        }
    }
}
