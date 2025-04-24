//
//  DemoProductViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 23.04.2025.
//

import RxSwift
import RxCocoa

final class DemoProductViewModel {
    enum Action {
        case close
    }
    
    private let demoProduct: Driver<DemoProduct.Product>
    
    init(demoProduct: DemoProduct.Product) {
        self.demoProduct = BehaviorRelay(value: demoProduct).asDriver()
    }
}

// MARK: Public
extension DemoProductViewModel {
    struct Input {
        let didTapClose: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let elements: Driver<[DemoProductTableElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didTapClose: input.didTapClose),
            elements: makeElements(demoProduct: demoProduct)
        )
    }
}

// MARK: Private
private extension DemoProductViewModel {
    func makeAction(didTapClose: Signal<Void>) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close)
    }
    
    func makeElements(demoProduct: Driver<DemoProduct.Product>) -> Driver<[DemoProductTableElement]> {
        demoProduct.map { demoProduct -> [DemoProductTableElement] in
            switch demoProduct {
            case .stanleyCup:
                let general = DPTableGeneralElement(
                    photoName: "DemoProduct.SC",
                    title: "DemoProduct.SP.Title".localized,
                    count: 15,
                    priceValue: 33,
                    priceCurrency: .dollar
                )
                
                let barcode = Barcode(value: "051111407592", type: .code128)
                
                return [.general(general), .barcode(barcode)]
            case .vitaminC:
                let general = DPTableGeneralElement(
                    photoName: "DemoProduct.VitaminC",
                    title: "DemoProduct.VitaminC.Title".localized,
                    count: 765,
                    priceValue: 14,
                    priceCurrency: .dollar
                )
                
                let barcode = Barcode(value: "051111407592", type: .code128)
                
                return [.general(general), .barcode(barcode)]
            }
        }
    }
}
