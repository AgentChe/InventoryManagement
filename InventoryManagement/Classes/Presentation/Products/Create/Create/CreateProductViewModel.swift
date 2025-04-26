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
        let didCreatedNewField: Signal<ProductMetaField>
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
        let metaFieldsElements = makeMetaFieldsElements(
            initialDetails: initialDetailsData,
            didCreatedNewField: input.didCreatedNewField
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
            metaFieldsElements: metaFieldsElements,
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
                saveEnable: saveEnable,
                metaFieldsElements: metaFieldsElements
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
        let metaFields: [CPTableMetaFieldElement]?
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
                        let metaFields = data.metaFields ?? []
                        let meta = ProductMetaFieldsMapper().json(fields: metaFields.map { $0.metaField })
                        
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
                                    meta: meta,
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
                                    meta: meta,
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
                                    meta: meta
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
        metaFieldsElements: Driver<[CPTableMetaFieldElement]>,
        relate: Driver<[String: Any]?>
    ) -> Driver<SaveData> {
        Driver
            .combineLatest(title, images, count, barcode, price, metaFieldsElements, relate)
            .compactMap { title, images, count, barcode, price, metaFields, relate -> SaveData? in
                guard let title, !images.isEmpty, let count, let barcode, let price else { return nil }
                
                return SaveData(
                    title: title,
                    images: images.map { $0.absoluteString },
                    count: count,
                    barcode: barcode.value,
                    priceValue: price.value,
                    priceCurrency: price.currency,
                    metaFields: metaFields,
                    relate: relate
                )
            }
    }
    
    func makeElements(
        generalElement: Driver<CPTableGeneralElement>,
        barcode: Driver<Barcode?>,
        saveEnable: Driver<Bool>,
        metaFieldsElements: Driver<[CPTableMetaFieldElement]>
    ) -> Driver<[CreateProductTableElement]> {
        Driver
            .combineLatest(generalElement, barcode, saveEnable, metaFieldsElements)
            .map { generalElement, barcode, saveEnable, metaFields -> [CreateProductTableElement] in
                var elements: [CreateProductTableElement] = [.general(generalElement)]
                
                elements.append(contentsOf: metaFields.map { .metaField($0) })
                elements.append(.addFields)
                
                if let barcode {
                    elements.append(.barcode(barcode))
                } else {
                    elements.append(.addBarcode)
                }
                
                elements.append(.save(saveEnable))
                
                return elements
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
    
    func makeMetaFieldsElements(
        initialDetails: Driver<DetailsData>,
        didCreatedNewField: Signal<ProductMetaField>
    ) -> Driver<[CPTableMetaFieldElement]> {
        initialDetails
            .map { $0.meta }
            .flatMapLatest { initialMetaFields -> Driver<[CPTableMetaFieldElement]> in
                enum Action {
                    case newField(ProductMetaField)
                }
                
                let newFieldAction = didCreatedNewField
                    .map { Action.newField($0) }
                    .asDriver(onErrorDriveWith: .never())
                
                let action = Driver.merge(newFieldAction)
                
                let initialMetaFieldsElements = initialMetaFields.compactMap { CPTableMetaFieldElement(metaField: $0) }
                
                return action
                    .scan(initialMetaFieldsElements) { fields, action -> [CPTableMetaFieldElement] in
                        switch action {
                        case .newField(let field):
                            return fields + [CPTableMetaFieldElement(metaField: field)].compactMap { $0 }
                        }
                    }
                    .startWith(initialMetaFieldsElements)
            }
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

// MARK: Additional
private extension CPTableMetaFieldElement {
    init?(metaField: ProductMetaField) {
        if let field = metaField as? SmallTextBoxField {
            let element = CPTSmallTextBoxFieldElement(field: field)
            self = .smallTextBox(element)
        } else if let field = metaField as? LargeTextBoxField {
            let element = CPTLargeTextBoxFieldElement(field: field)
            self = .largeTextBox(element)
        } else if let field = metaField as? RoundNumberField {
            let element = CPTRoundNumberFieldElement(field: field)
            self = .roundNumber(element)
        } else if let field = metaField as? DecimalNumberField {
            let element = CPTDecimalNumberFieldElement(field: field)
            self = .decimalNumber(element)
        } else if let field = metaField as? CheckboxField {
            let element = CPTCheckboxFieldElement(field: field)
            self = .checkBox(element)
        } else if let field = metaField as? DateField {
            let element = CPTDateFieldElement(field: field)
            self = .date(element)
        } else if let field = metaField as? PhoneNumberField {
            let element = CPTPhoneNumberFieldElement(field: field)
            self = .phoneNumber(element)
        } else if let field = metaField as? WebLinkField {
            let element = CPTWebLinkFieldElement(field: field)
            self = .webLink(element)
        } else if let field = metaField as? EmailField {
            let element = CPTEmailFieldElement(field: field)
            self = .email(element)
        } else {
            return nil
        }
    }
    
    var metaField: ProductMetaField {
        switch self {
        case .smallTextBox(let element):
            return SmallTextBoxField(
                id: element.id,
                name: element.name,
                text: element.text
            )
        case .largeTextBox(let element):
            return LargeTextBoxField(
                id: element.id,
                name: element.name,
                text: element.text
            )
        case .roundNumber(let element):
            return RoundNumberField(
                id: element.id,
                name: element.name,
                number: element.number
            )
        case .decimalNumber(let element):
            return DecimalNumberField(
                id: element.id,
                name: element.name,
                number: element.number
            )
        case .checkBox(let element):
            return CheckboxField(
                id: element.id,
                name: element.name,
                value: element.value
            )
        case .date(let element):
            return DateField(
                id: element.id,
                name: element.name,
                date: element.date
            )
        case .phoneNumber(let element):
            return PhoneNumberField(
                id: element.id,
                name: element.name,
                phoneNumber: element.phoneNumber
            )
        case .webLink(let element):
            return WebLinkField(
                id: element.id,
                name: element.name,
                link: element.link
            )
        case .email(let element):
            return EmailField(
                id: element.id,
                name: element.name,
                email: element.email
            )
        }
    }
}
