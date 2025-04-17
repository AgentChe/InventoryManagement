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
        case addFields
        case addBarcode
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
        let didDeletePhoto: Signal<URL>
        let didTapAddNewPhoto: Signal<Void>
        let didAddedNewPhoto: Signal<UIImage>
        let didChangedTitle: Signal<String>
        let didChangedCount: Signal<Int?>
        let didChangedPriceValue: Signal<Double?>
        let didChangedPriceCurrency: Signal<PriceCurrency>
        let didTapAddFields: Signal<Void>
        let didTapAddBarcode: Signal<Void>
        let didCreateNewBarcode: Signal<Barcode>
        let didTapSave: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let elements: Driver<[CreateProductTableElement]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let initialDetailsData = makeInitialDetailsData(source: source)
        let images = makeImages(
            initialDetails: initialDetailsData,
            didAddedNewPhoto: input.didAddedNewPhoto,
            didDeletePhoto: input.didDeletePhoto
        )
        let selectedImage = makeSelectedImage(
            images: images,
            didSelectPhoto: input.didSelectPhoto
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
            selectedImage: selectedImage,
            images: images,
            title: title,
            count: count,
            priceValue: priceValue,
            priceCurrency: priceCurrency
        )
        let barcode = makeBarcode(
            initialDetails: initialDetailsData,
            didCreateNewBarcode: input.didCreateNewBarcode
        )
        let saveEnable = makeSaveEnable(
            images: images,
            title: title,
            count: count,
            price: price,
            barcode: barcode
        )
        let saveData = makeSaveData(
            title: title,
            images: images,
            count: count,
            barcode: barcode,
            price: price,
            relate: initialDetailsData.map { $0.relate })
        
        return Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didTapAddNewPhoto: input.didTapAddNewPhoto,
                didTapAddFields: input.didTapAddFields,
                didTapAddBarcode: input.didTapAddBarcode,
                didTapSave: input.didTapSave,
                saveData: saveData,
                source: source
            ),
            elements: makeElements(
                generalElement: generalElement,
                barcode: barcode,
                saveEnable: saveEnable
            ),
            activity: activity.asDriver()
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
        let meta: [ProductMetaField]
        let relate: [String: Any]?
    }
    
    struct SaveData {
        let title: String
        let images: [String]
        let count: Int
        let barcode: String
        let priceValue: Double
        let priceCurrency: PriceCurrency
        let meta: [String: Any]?
        let relate: [String: Any]?
    }
    
    func makeAction(
        didTapClose: Signal<Void>,
        didTapAddNewPhoto: Signal<Void>,
        didTapAddFields: Signal<Void>,
        didTapAddBarcode: Signal<Void>,
        didTapSave: Signal<Void>,
        saveData: Driver<SaveData>,
        source: Driver<CreateProductViewController.Source>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let addNewPhoto = didTapAddNewPhoto
            .map { Action.addPhoto }
            .asDriver(onErrorDriveWith: .never())
        
        let addFields = didTapAddFields
            .map { Action.addFields }
            .asDriver(onErrorDriveWith: .never())
        
        let addBarcode = didTapAddBarcode
            .map { Action.addBarcode }
            .asDriver(onErrorDriveWith: .never())
        
        let save = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(saveData)
            .withLatestFrom(source) { ($0, $1) }
            .flatMapLatest { [weak self] data, source -> Driver<Action> in
                guard let self else { return .never() }
                
                func request() -> Single<Void> {
                    let requestResult: Single<RequestResult> = {
                        switch source {
                        case .scan:
                            return self.productsManager
                                .create(
                                    title: data.title,
                                    images: data.images,
                                    count: data.count,
                                    barcode: data.barcode,
                                    priceValue: data.priceValue,
                                    priceCurrency: data.priceCurrency.rawValue,
                                    meta: data.meta,
                                    relate: data.relate,
                                    creationMethod: .scan
                                )
                        case .manually:
                            return self.productsManager
                                .create(
                                    title: data.title,
                                    images: data.images,
                                    count: data.count,
                                    barcode: data.barcode,
                                    priceValue: data.priceValue,
                                    priceCurrency: data.priceCurrency.rawValue,
                                    meta: data.meta,
                                    relate: data.relate,
                                    creationMethod: .manual
                                )
                        case .edit(let product):
                            return self.productsManager
                                .edit(
                                    id: product.id,
                                    title: data.title,
                                    images: data.images,
                                    count: data.count,
                                    barcode: data.barcode,
                                    priceValue: data.priceValue,
                                    priceCurrency: data.priceCurrency.rawValue,
                                    meta: data.meta
                                )
                        }
                    }()
                    
                    return requestResult
                        .map { result -> Void in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Void()
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { request() },
                        trigger: { trigger(error: $0) }
                    )
                    .trackActivity(activity)
                    .asDriver(onErrorDriveWith: .never())
                    .map { Action.close }
            }
        
        return Driver
            .merge(close, addNewPhoto, addFields, addBarcode, save)
    }
    
    func makeSaveData(
        title: Driver<String?>,
        images: Driver<[URL]>,
        count: Driver<Int?>,
        barcode: Driver<Barcode?>,
        price: Driver<Price?>,
        relate: Driver<[String: Any]?>
    ) -> Driver<SaveData> {
        Driver
            .combineLatest(title, images, count, barcode, price, relate)
            .compactMap { title, images, count, barcode, price, relate -> SaveData? in
                guard let title, !images.isEmpty, let count, let barcode, let price else { return nil }
                
                return SaveData(
                    title: title,
                    images: images.map { $0.absoluteString },
                    count: count,
                    barcode: barcode.value,
                    priceValue: price.value,
                    priceCurrency: price.currency,
                    meta: nil,
                    relate: relate
                )
            }
    }
    
    func makeElements(
        generalElement: Driver<CPTableGeneralElement>,
        barcode: Driver<Barcode?>,
        saveEnable: Driver<Bool>
    ) -> Driver<[CreateProductTableElement]> {
        Driver
            .combineLatest(generalElement, barcode, saveEnable)
            .map { generalElement, barcode, saveEnable -> [CreateProductTableElement] in
                [
                    .general(generalElement),
                    .addFields,
                    {
                        guard let barcode else { return .addBarcode }
                        return .barcode(barcode)
                    }(),
                    .save(saveEnable)
                ]
            }
    }
    
    func makeGeneralElement(
        selectedImage: Driver<URL?>,
        images: Driver<[URL]>,
        title: Driver<String?>,
        count: Driver<Int?>,
        priceValue: Driver<Double?>,
        priceCurrency: Driver<PriceCurrency>
    ) -> Driver<CPTableGeneralElement> {
        Driver
            .combineLatest(images, selectedImage, priceCurrency)
            .withLatestFrom(title) { ($0.0, $0.1, $0.2, $1) }
            .withLatestFrom(count) { ($0.0, $0.1, $0.2, $0.3, $1) }
            .withLatestFrom(priceValue) { ($0.0, $0.1, $0.2, $0.3, $0.4, $1) }
            .map { images, selectedPhoto, priceCurrency, title, count, priceValue -> CPTableGeneralElement in
                let selectedPhoto = selectedPhoto ?? images.first
                
                let photos: [CPPhotosCollectionElement] = {
                    guard !images.isEmpty else { return [] }
                    
                    let photos = images.map { url -> CPPhotosCollectionElement in
                        let element = CPPCollectionPhotoElement(
                            url: url,
                            selected: url == selectedPhoto
                        )
                        return .photo(element)
                    }
                    
                    return photos + [.add]
                }()
                
                return CPTableGeneralElement(
                    photos: photos,
                    selectedPhoto: selectedPhoto,
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
        didChangedCount: Signal<Int?>
    ) -> Driver<Int?> {
        Driver
            .merge(
                initialDetails.map { $0.count },
                didChangedCount.asDriver(onErrorDriveWith: .never())
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
        didChangedPriceValue: Signal<Double?>
    ) -> Driver<Double?> {
        Driver
            .merge(
                initialDetails.map { $0.priceValue },
                didChangedPriceValue.asDriver(onErrorDriveWith: .never())
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
    
    func makeSelectedImage(
        images: Driver<[URL]>,
        didSelectPhoto: Signal<URL>
    ) -> Driver<URL?> {
        let selected = didSelectPhoto
            .map { image -> URL? in image }
            .startWith(nil)
            .asDriver(onErrorDriveWith: .never())
        
        let changeImages = images
            .withLatestFrom(selected) { ($0, $1) }
            .map { images, selected -> URL? in
                guard let selected else {
                    return images.first
                }
                
                return images.contains(selected) ? selected : images.first
            }
        
        return Driver
            .merge(selected, changeImages)
    }
    
    func makeImages(
        initialDetails: Driver<DetailsData>,
        didAddedNewPhoto: Signal<UIImage>,
        didDeletePhoto: Signal<URL>
    ) -> Driver<[URL]> {
        initialDetails
            .map { $0.images ?? [] }
            .flatMapLatest { initialImages -> Driver<[URL]> in
                enum Action {
                    case newImage(URL)
                    case deleteImage(URL)
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
                
                let deleteImage = didDeletePhoto
                    .map { Action.deleteImage($0) }
                    .asDriver(onErrorDriveWith: .never())
                
                let action = Driver.merge(newImage, deleteImage)
                
                return action
                    .scan(initialImages) { images, action -> [URL] in
                        switch action {
                        case .newImage(let url):
                            return images + [url]
                        case .deleteImage(let url):
                            var result = images
                            result.removeAll(where: { $0 == url })
                            return result
                        }
                    }
                    .startWith(initialImages)
            }
    }
    
    func makeBarcode(
        initialDetails: Driver<DetailsData>,
        didCreateNewBarcode: Signal<Barcode>
    ) -> Driver<Barcode?> {
        let initial = initialDetails
            .map { initialDetails -> Barcode? in
                guard let barcodeValue = initialDetails.barcode else {
                    return nil
                }
                
                return Barcode(value: barcodeValue, type: .code128)
            }
    
        let createNew = didCreateNewBarcode
            .map { barcode -> Barcode? in barcode }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, createNew)
    }
    
    func makeSaveEnable(
        images: Driver<[URL]>,
        title: Driver<String?>,
        count: Driver<Int?>,
        price: Driver<Price?>,
        barcode: Driver<Barcode?>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(images, title, count, price, barcode)
            .map { images, title, count, price, barcode -> Bool in
                let hasEmpty = [
                    images.isEmpty,
                    (title ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    count == nil,
                    price == nil,
                    barcode == nil
                ]
                return !hasEmpty.contains(true)
            }
            .distinctUntilChanged()
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
            case .edit(let product):
                func source() -> Single<DetailsData> {
                    productsManager
                        .obtainDetails(id: product.id)
                        .map { details -> DetailsData in
                            guard let details else { throw ContentError(.notContent) }
                            return DetailsData(product: details)
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
        meta = []
        relate = nil
    }
    
    init(scanResult: ProductScanBarcodeResult) {
        title = scanResult.title
        images = scanResult.images
        count = nil
        barcode = scanResult.barcode
        priceValue = scanResult.price?.value
        priceCurrency = scanResult.price?.currency ?? .dollar
        meta = []
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
