//
//  ProductsManager.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import RxSwift

protocol ProductsManagerProtocol {
    func scan(barcode: String) -> Single<ProductScanBarcodeResult?>
    func create(
        title: String,
        images: [String],
        count: Int,
        barcode: String,
        priceValue: Double,
        priceCurrency: String,
        meta: [String: Any]?,
        relate: [String: Any]?
    ) -> Single<RequestResult>
    func obtainDetails(id: String) -> Single<ProductDetails?>
    func upload(image: UIImage) -> Single<UploadImageResult?>
    func obtainProducts(
        search: String?,
        folderId: String?,
        page: Int
    ) -> Single<Page<[Product]>?>
}

final class ProductsManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: ProductsManagerProtocol
extension ProductsManager: ProductsManagerProtocol {
    // TODO
    func scan(barcode: String) -> Single<ProductScanBarcodeResult?> {
//        let request = ScanBarcodeRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId,
//            barcode: barcode
//        )
//        
//        return restAPITransport
//            .callServerApi(requestBody: request)
//            .map { ProductScanBarcodeResult.map(response: $0) }
        
        Single<ProductScanBarcodeResult?>.create { single in
            let result = scanMock()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                single(.success(result))
            })
            
            return Disposables.create()
        }
    }
    
    func create(
        title: String,
        images: [String],
        count: Int,
        barcode: String,
        priceValue: Double,
        priceCurrency: String,
        meta: [String: Any]?,
        relate: [String: Any]?
    ) -> Single<RequestResult> {
        let request = CreateProductRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            title: title,
            images: images,
            count: count,
            barcode: barcode,
            priceValue: priceValue,
            priceCurrency: priceCurrency,
            meta: meta,
            relate: relate
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                ProductsMediator.shared.notifyCreateProduct()
            })
    }
    
    func obtainDetails(id: String) -> Single<ProductDetails?> {
        let request = ObtainProductDetailsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { ProductDetails.map(response: $0) }
    }
    
    // TODO
    func upload(image: UIImage) -> Single<UploadImageResult?> {
//        let request = UploadImageRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId,
//            image: image
//        )
//        
//        return restAPITransport
//            .callServerApi(formDataBody: request)
//            .map { UploadImageResult.map(response: $0) }
        
        Single<UploadImageResult?>.create { single in
            
            let urls = [
                URL(string: "https://i.postimg.cc/1tPYX9xW/temp-Imagewn-Bj-RZ.avif")!,
                URL(string: "https://i.postimg.cc/qRjJGsKy/temp-Imagey-O3-Md-Y.avif")!,
                URL(string: "https://i.postimg.cc/52R8szBc/temp-Image9s-D4vo.avif")!
            ]
            let result = UploadImageResult(url: urls.randomElement()!)
            single(.success(result))
            
            return Disposables.create()
        }
    }
    
    // TODO
    func obtainProducts(
        search: String? = nil,
        folderId: String? = nil,
        page: Int
    ) -> Single<Page<[Product]>?> {
//        let request = ObtainProductsRequest(
//            anonymousId: sessionManager.anonymousId,
//            internalId: sessionManager.internalId,
//            search: search,
//            folderId: folderId,
//            page: page
//        )
//        
//        return restAPITransport
//            .callServerApi(requestBody: request)
//            .map { Product.map(response: $0) }
        
        Single<Page<[Product]>?>.create { single in
            let products = productsMock(count: [0, 10].randomElement()!)
            let pageInfo = PageInfo(current: page, next: page + 1, total: 5)
            let page = Page(info: pageInfo, elements: products)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                single(.success(page))
            })
            
            return Disposables.create()
        }
    }
}

// TODO: remove
func productsMock(count: Int = 10) -> [Product] {
    guard count > 0 else { return [] }
    
    let letters = "abcdefghijklmnopqrstuvwxyz"
    let barcodeLetters = "abcdefghijklmnopqrstuvwxyz0123456789"
    
    return Array(0...count).map { i -> Product in
        let nameCount = Int.random(in: 5...15)
        
        return Product(
            id: String(i),
            title: String((0..<nameCount).map{ _ in letters.randomElement()! }),
            image: URL(string: "https://i.postimg.cc/htfyMgQL/temp-Imagewsizoa.avif")!,
            countLocalized: "\(Int.random(in: 1...5)) unit",
            barcode: String((0..<nameCount).map{ _ in barcodeLetters.randomElement()! }).uppercased()
        )
    }
}

func scanMock() -> ProductScanBarcodeResult {
    let letters = "abcdefghijklmnopqrstuvwxyz"
    let barcodeLetters = "abcdefghijklmnopqrstuvwxyz0123456789"
    
    let urls = [
        URL(string: "https://i.postimg.cc/1tPYX9xW/temp-Imagewn-Bj-RZ.avif")!,
        URL(string: "https://i.postimg.cc/qRjJGsKy/temp-Imagey-O3-Md-Y.avif")!,
        URL(string: "https://i.postimg.cc/52R8szBc/temp-Image9s-D4vo.avif")!
    ]
    
    return ProductScanBarcodeResult(
        title: String((0..<20).map{ _ in letters.randomElement()! }),
        images: urls,
        price: Price(
            value: Double.random(in: 1...100),
            currency: PriceCurrency.dollar
        ),
        barcode: "051111407592",
        relate: nil
    )
}
