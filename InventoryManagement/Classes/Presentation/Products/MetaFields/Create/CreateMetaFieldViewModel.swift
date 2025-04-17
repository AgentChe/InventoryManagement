//
//  CreateMetaFieldViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import RxSwift
import RxCocoa

final class CreateMetaFieldViewModel {
    enum Action {
        case back
    }
}

// MARK: Public
extension CreateMetaFieldViewModel {
    struct Input {
        let didTapBack: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didTapBack: input.didTapBack)
        )
    }
}

// MARK: Private
private extension CreateMetaFieldViewModel {
    func makeAction(didTapBack: Signal<Void>) -> Driver<Action> {
        didTapBack
            .map { Action.back }
            .asDriver(onErrorDriveWith: .never())
    }
}
