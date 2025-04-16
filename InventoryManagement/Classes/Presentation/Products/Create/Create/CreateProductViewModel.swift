//
//  CreateProductViewModel.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 11.04.2025.
//

import RxSwift
import RxCocoa

final class CreateProductViewModel {
    enum Action {
        case close
        case addPhoto
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private let source: Driver<CreateProductViewController.Source>
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var productsManager = ProductsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(source: CreateProductViewController.Source) {
        self.source = BehaviorRelay(value: source).asDriver()
    }
}

// MARK: Public
extension CreateProductViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didSelectPhoto: Signal<URL>
        let didTapAddNewPhoto: Signal<Void>
        let didAddedNewPhoto: Signal<UIImage>
        let didChangedTitle: Signal<String>
        let didChangedCount: Signal<Int>
        let didChangedPriceValue: Signal<Double>
        let didChangedPriceCurrency: Signal<PriceCurrency>
    }
    
    struct Output {
        let action: Driver<Action>
        let elements: Driver<[CreateProductTableElement]>
    }
    
    func configure(input: Input) -> Output {
        let initialDetailsData = makeInitialDetailsData(source: source)
        let images = makeImages(
            initialDetails: initialDetailsData,
            didAddedNewPhoto: input.didAddedNewPhoto
        )
        let title = makeTitle(
            initialDetails: initialDetailsData,
            didChangedTitle: input.didChangedTitle
        )
        let count = makeCount(
            initialDetails: initialDetailsData,
            didChangedCount: input.didChangedCount
        )
        let priceValue = makePriceValue(
            initialDetails: initialDetailsData,
            didChangedPriceValue: input.didChangedPriceValue
        )
        let priceCurrency = makePriceCurrency(
            initialDetails: initialDetailsData,
            didChangedPriceCurrency: input.didChangedPriceCurrency
        )
        let price = makePrice(
            priceValue: priceValue,
            priceCurrency: priceCurrency
        )
        let generalElement = makeGeneralElement(
            initialDetails: initialDetailsData,
            didSelectPhoto: input.didSelectPhoto,
            images: images,
            title: title,
            count: count,
            priceValue: priceValue,
            priceCurrency: priceCurrency
        )
        
        return Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didTapAddNewPhoto: input.didTapAddNewPhoto
            ),
            elements: makeElements(generalElement: generalElement)
        )
    }
}

// MARK: Private
private extension CreateProductViewModel {
    struct DetailsData {
        let title: String?
        let images: [URL]?
        let count: Int?
        let barcode: String?
        let priceValue: Double?
        let priceCurrency: PriceCurrency
        let meta: [String: Any]?
        let relate: [String: Any]?
    }
    
    func makeAction(
        didTapClose: Signal<Void>,
        didTapAddNewPhoto: Signal<Void>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let addNewPhoto = didTapAddNewPhoto
            .map { Action.addPhoto }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, addNewPhoto)
    }
    
    func makeElements(
        generalElement: Driver<CPTableGeneralElement>
    ) -> Driver<[CreateProductTableElement]> {
        generalElement
            .map { [.general($0)] }
            .startWith([])
    }
    
    func makeGeneralElement(
        initialDetails: Driver<DetailsData>,
        didSelectPhoto: Signal<URL>,
        images: Driver<[URL]>,
        title: Driver<String?>,
        count: Driver<Int?>,
        priceValue: Driver<Double?>,
        priceCurrency: Driver<PriceCurrency>
    ) -> Driver<CPTableGeneralElement> {
        let selectedPhoto = Driver<URL?>
            .merge(
                initialDetails.map { $0.images?.first },
                didSelectPhoto
                    .map { url -> URL? in url }
                    .asDriver(onErrorDriveWith: .never())
            )
        
        return Driver
            .combineLatest(images, selectedPhoto, priceCurrency)
            .withLatestFrom(title) { ($0.0, $0.1, $0.2, $1) }
            .withLatestFrom(count) { ($0.0, $0.1, $0.2, $0.3, $1) }
            .withLatestFrom(priceValue) { ($0.0, $0.1, $0.2, $0.3, $0.4, $1) }
            .map { images, selectedPhoto, priceCurrency, title, count, priceValue -> CPTableGeneralElement in
                CPTableGeneralElement(
                    photos: images.map { .photo($0) } + { images.isEmpty ? [] : [.add] }(),
                    selectedPhoto: selectedPhoto ?? images.first,
                    title: title,
                    count: count,
                    priceValue: priceValue,
                    priceCurrency: priceCurrency
                )
            }
    }
    
    func makeTitle(
        initialDetails: Driver<DetailsData>,
        didChangedTitle: Signal<String>
    ) -> Driver<String?> {
        Driver
            .merge(
                initialDetails.map { $0.title },
                didChangedTitle
                    .asDriver(onErrorDriveWith: .never())
                    .map { title -> String? in title }
            )
    }
    
    func makeCount(
        initialDetails: Driver<DetailsData>,
        didChangedCount: Signal<Int>
    ) -> Driver<Int?> {
        Driver
            .merge(
                initialDetails.map { $0.count },
                didChangedCount
                    .asDriver(onErrorDriveWith: .never())
                    .map { count -> Int? in count }
            )
    }
    
    func makePrice(
        priceValue: Driver<Double?>,
        priceCurrency: Driver<PriceCurrency>
    ) -> Driver<Price?> {
        Driver
            .combineLatest(priceValue, priceCurrency)
            .map { priceValue, priceCurrency -> Price? in
                guard let priceValue else { return nil }
                return Price(value: priceValue, currency: priceCurrency)
            }
    }
    
    func makePriceValue(
        initialDetails: Driver<DetailsData>,
        didChangedPriceValue: Signal<Double>
    ) -> Driver<Double?> {
        Driver
            .merge(
                initialDetails.map { $0.priceValue },
                didChangedPriceValue
                    .asDriver(onErrorDriveWith: .never())
                    .map { price -> Double? in price }
            )
    }
    
    func makePriceCurrency(
        initialDetails: Driver<DetailsData>,
        didChangedPriceCurrency: Signal<PriceCurrency>
    ) -> Driver<PriceCurrency> {
        Driver
            .merge(
                initialDetails.map { $0.priceCurrency },
                didChangedPriceCurrency
                    .asDriver(onErrorDriveWith: .never())
            )
    }
    
    func makeImages(
        initialDetails: Driver<DetailsData>,
        didAddedNewPhoto: Signal<UIImage>
    ) -> Driver<[URL]> {
        initialDetails
            .map { $0.images ?? [] }
            .flatMapLatest { initialImages -> Driver<[URL]> in
                enum Action {
                    case newImage(URL)
                }
                
                let newImage = didAddedNewPhoto
                    .flatMap { [weak self] image -> Driver<URL> in
                        guard let self else { return .never() }
                        
                        return productsManager
                            .upload(image: image)
                            .compactMap { $0?.url }
                            .asDriver(onErrorDriveWith: .never())
                    }
                    .map { Action.newImage($0) }
                
                let action = Driver.merge(newImage)
                
                return action
                    .scan(initialImages) { images, action -> [URL] in
                        switch action {
                        case .newImage(let url):
                            return images + [url]
                        }
                    }
                    .startWith(initialImages)
            }
    }
    
    func makeInitialDetailsData(source: Driver<CreateProductViewController.Source>) -> Driver<DetailsData> {
        source.flatMapLatest { [weak self] source -> Driver<DetailsData> in
            guard let self else { return .never() }
            
            switch source {
            case .manually:
                let data = DetailsData()
                return .just(data)
            case .scan(let barcode):
                func source() -> Single<DetailsData> {
                    productsManager
                        .scan(barcode: barcode.value)
                        .map { result -> DetailsData in
                            guard let result else { throw ContentError(.notContent) }
                            return DetailsData(scanResult: result)
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
            case .details(let productDetails):
                let data = DetailsData(product: productDetails)
                return .just(data)
            }
        }
    }
}

// MARK: Additional
private extension CreateProductViewModel.DetailsData {
    init() {
        title = nil
        images = nil
        count = nil
        barcode = nil
        priceValue = nil
        priceCurrency = .dollar
        meta = nil
        relate = nil
    }
    
    init(scanResult: ProductScanBarcodeResult) {
        title = scanResult.title
        images = scanResult.images
        count = nil
        barcode = scanResult.barcode
        priceValue = scanResult.price?.value
        priceCurrency = scanResult.price?.currency ?? .dollar
        meta = nil
        relate = scanResult.relate
    }
    
    init(product: ProductDetails) {
        title = product.title
        images = product.images
        count = product.count
        barcode = product.barcode
        priceValue = product.price.value
        priceCurrency = product.price.currency
        meta = product.meta
        relate = nil
    }
}
