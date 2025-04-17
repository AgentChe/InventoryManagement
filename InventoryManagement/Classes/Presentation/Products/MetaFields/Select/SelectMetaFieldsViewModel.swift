//
//  SelectMetaFieldsViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import RxSwift
import RxCocoa

final class SelectMetaFieldsViewModel {
    enum Action {
        case createField(CreateMetaFieldViewController.Field)
    }
}

// MARK: Public
extension SelectMetaFieldsViewModel {
    struct Input {
        let didSelect: Signal<SMFTableElement>
    }
    
    struct Output {
        let elements: Driver<[SMFTableElement]>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(),
            action: makeAction(didSelect: input.didSelect)
        )
    }
}

// MARK: Private
private extension SelectMetaFieldsViewModel {
    func makeElements() -> Driver<[SMFTableElement]> {
        Single
            .create { single in
                let elements: [SMFTableElement] = [
                    .smallTextBox,
                    .largeTextBox,
                    .roundNumber,
                    .decimalNumber,
                    .checkbox,
                    .date,
                    .phoneNumber,
                    .webLink,
                    .email
                ]
                single(.success(elements))
                
                return Disposables.create()
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeAction(didSelect: Signal<SMFTableElement>) -> Driver<Action> {
        didSelect
            .map { element -> CreateMetaFieldViewController.Field in
                switch element {
                case .smallTextBox:
                    return .smallTextBox
                case .largeTextBox:
                    return .largeTextBox
                case .roundNumber:
                    return .roundNumber
                case .decimalNumber:
                    return .decimalNumber
                case .checkbox:
                    return .checkbox
                case .date:
                    return .date
                case .phoneNumber:
                    return .phoneNumber
                case .webLink:
                    return .webLink
                case .email:
                    return .email
                }
            }
            .map { Action.createField($0) }
            .asDriver(onErrorDriveWith: .never())
    }
}
