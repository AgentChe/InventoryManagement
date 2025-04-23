//
//  CreateFolderViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateFolderViewController: UIViewController {
    enum Mode {
        case create
        case edit(Folder)
    }
    
    private let mainView: CreateFolderView
    
    private let viewModel: CreateFolderViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(mode: Mode) {
        mainView = CreateFolderView(mode: mode)
        viewModel = CreateFolderViewModel(mode: mode)
        
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
        
        let didTapSave = mainView.saveButton.rx.tap
            .compactMap { [weak self] void -> String? in
                self?.mainView.textField.text
            }
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .asSignal(onErrorSignalWith: .never())
        
        didTapSave
            .map { _ in Void() }
            .emit(to: mainView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: CreateFolderViewModel.Input(
            didTapSave: didTapSave
        ))
        
        output.activity
            .drive(Binder(mainView) { base, activity in
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
                
                base.saveButton.isHidden = activity
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mainView.animateShow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        dismiss()
    }
}

// MARK: Public
extension CreateFolderViewController {
    static func create() -> CreateFolderViewController {
        let vc = CreateFolderViewController(mode: .create)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    static func edit(folder: Folder) -> CreateFolderViewController {
        let vc = CreateFolderViewController(mode: .edit(folder))
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension CreateFolderViewController {
    func action(_ action: CreateFolderViewModel.Action) {
        switch action {
        case .close:
            dismiss()
        }
    }
    
    func dismiss() {
        mainView.animateDismiss { [weak self] in
            self?.dismiss(animated: false)
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
