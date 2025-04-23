//
//  CreateFolderViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import RxSwift
import RxCocoa

final class CreateFolderViewModel {
    enum Action {
        case close
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var activity = RxActivityIndicator()
    
    private let mode: Driver<CreateFolderViewController.Mode>
    
    private lazy var foldersManager = FoldersManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(mode: CreateFolderViewController.Mode) {
        self.mode = BehaviorRelay(value: mode).asDriver()
    }
}

// MARK: Public
extension CreateFolderViewModel {
    struct Input {
        let didTapSave: Signal<String>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            activity: activity.asDriver(),
            action: makeAction(
                didTapSave: input.didTapSave,
                mode: mode
            )
        )
    }
}

// MARK: Private
private extension CreateFolderViewModel {
    func makeAction(
        didTapSave: Signal<String>,
        mode: Driver<CreateFolderViewController.Mode>
    ) -> Driver<Action> {
        let save = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(mode) { ($0, $1) }
            .flatMapLatest { [weak self] title, mode -> Driver<Action> in
                guard let self else { return .never() }
                
                func source() -> Single<Action> {
                    switch mode {
                    case .create:
                        return foldersManager
                            .create(title: title, notes: nil)
                            .map { folder -> Action in
                                if folder == nil {
                                    throw ContentError(.notContent)
                                }
                                
                                return Action.close
                            }
                    case .edit(let folder):
                        return foldersManager
                            .rename(
                                id: folder.id,
                                title: title,
                                notes: nil
                            )
                            .map { result -> Action in
                                guard result.success else {
                                    throw ContentError(.notContent)
                                }
                                
                                return Action.close
                            }
                    }
                }
                    
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }

                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(save)
    }
}
