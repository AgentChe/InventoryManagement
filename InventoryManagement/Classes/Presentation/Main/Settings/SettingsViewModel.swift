//
//  SettingsViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 08.04.2025.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    enum Route {
        case paygate
        case url(URL)
    }
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didTapUnlockAccess: Signal<Void>
        let didTapLink: Signal<STLinkButton.Link>
    }
    
    struct Output {
        let elements: Driver<[SettingsTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(activeSubscription: makeActiveSubscription()),
            route: makeRoute(
                didTapUnlockAccess: input.didTapUnlockAccess,
                didTapLink: input.didTapLink
            )
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeElements(activeSubscription: Driver<Bool>) -> Driver<[SettingsTableElement]> {
        activeSubscription
            .map { activeSubscription -> [SettingsTableElement] in
                activeSubscription ? [.links] : [.unlockAccess, .links]
            }
    }
    
    func makeRoute(
        didTapUnlockAccess: Signal<Void>,
        didTapLink: Signal<STLinkButton.Link>
    ) -> Driver<Route> {
        let paygate = didTapUnlockAccess
            .map { Route.paygate }
            .asDriver(onErrorDriveWith: .never())
        
        let url = didTapLink
            .map { link -> URL in
                switch link {
                case .contactUs:
                    return GlobalDefinitions.contactUsUrl
                case .termsOfUse:
                    return GlobalDefinitions.termsOfServiceUrl
                case .privacyPolicy:
                    return GlobalDefinitions.privacyPolicyUrl
                }
            }
            .map { Route.url($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(paygate, url)
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
