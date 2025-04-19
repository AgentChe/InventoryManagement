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
        case createField
    }
}

// MARK: Public
extension CreateMetaFieldViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didTapCreate: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapBack: input.didTapBack,
                didTapCreate: input.didTapCreate
            )
        )
    }
}

// MARK: Private
private extension CreateMetaFieldViewModel {
    func makeAction(
        didTapBack: Signal<Void>,
        didTapCreate: Signal<Void>
    ) -> Driver<Action> {
        let back = didTapBack
            .map { Action.back }
            .asDriver(onErrorDriveWith: .never())
        
        let createField = didTapCreate
            .map { Action.createField }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(back, createField)
    }
}
