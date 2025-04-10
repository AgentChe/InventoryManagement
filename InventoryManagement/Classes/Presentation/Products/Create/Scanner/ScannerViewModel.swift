//
//  ScannerViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import RxSwift
import RxCocoa

final class ScannerViewModel {
    enum Action {
        case close
        case toggleFlash
        case detectBarcodeFromGallery
        case notifyErrorDetectBarcode
        case result(Barcode)
    }
}

// MARK: Public
extension ScannerViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapFlash: Signal<Void>
        let didTapWallpapers: Signal<Void>
        let didDetectedBarcode: Signal<Barcode?>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didTapFlash: input.didTapFlash,
                didTapWallpapers: input.didTapWallpapers,
                didDetectedBarcode: input.didDetectedBarcode
            )
        )
    }
}

// MARK: Private
private extension ScannerViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didTapFlash: Signal<Void>,
        didTapWallpapers: Signal<Void>,
        didDetectedBarcode: Signal<Barcode?>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let toggleFlash = didTapFlash
            .map { Action.toggleFlash }
            .asDriver(onErrorDriveWith: .never())
        
        let detectBarcodeFromGallery = didTapWallpapers
            .map { Action.detectBarcodeFromGallery }
            .asDriver(onErrorDriveWith: .never())
        
        let detected = didDetectedBarcode
            .compactMap { code -> Action? in
                guard let code else { return .notifyErrorDetectBarcode }
                return .result(code)
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, toggleFlash, detectBarcodeFromGallery, detected)
    }
}
