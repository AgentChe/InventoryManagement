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
        relate: [String: Any]?,
        creationMethod: CreateProductRequest.CreationMethod
    ) -> Single<RequestResult>
    func edit(
        id: String,
        title: String,
        images: [String],
        count: Int,
        barcode: String,
        priceValue: Double,
        priceCurrency: String,
        meta: [String: Any]?
    ) -> Single<RequestResult>
    func obtainDetails(id: String) -> Single<ProductDetails?>
    func upload(image: UIImage) -> Single<UploadImageResult?>
    func obtainProducts(
        search: String?,
        folderId: String?,
        page: Int
    ) -> Single<Page<[Product]>?>
    func delete(id: String) -> Single<RequestResult>
    func duplicate(id: String) -> Single<RequestResult>
}

final class ProductsManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: ProductsManagerProtocol
extension ProductsManager: ProductsManagerProtocol {
    func scan(barcode: String) -> Single<ProductScanBarcodeResult?> {
        let request = ScanBarcodeRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            barcode: barcode
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { ProductScanBarcodeResult.map(response: $0) }
    }
    
    func create(
        title: String,
        images: [String],
        count: Int,
        barcode: String,
        priceValue: Double,
        priceCurrency: String,
        meta: [String: Any]?,
        relate: [String: Any]?,
        creationMethod: CreateProductRequest.CreationMethod
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
            relate: relate,
            creationMethod: creationMethod
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                ProductsMediator.shared.notifyCreateProduct()
            })
    }
    
    func edit(
        id: String,
        title: String,
        images: [String],
        count: Int,
        barcode: String,
        priceValue: Double,
        priceCurrency: String,
        meta: [String: Any]?
    ) -> Single<RequestResult> {
        let request = EditProductRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id,
            title: title,
            images: images,
            count: count,
            barcode: barcode,
            priceValue: priceValue,
            priceCurrency: priceCurrency,
            meta: meta
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                ProductsMediator.shared.notifyEditeProduct(id: id)
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
    
    func upload(image: UIImage) -> Single<UploadImageResult?> {
        let request = UploadImageRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            image: image
        )
        
        return restAPITransport
            .callServerApi(formDataBody: request)
            .map { UploadImageResult.map(response: $0) }
    }
    
    func obtainProducts(
        search: String? = nil,
        folderId: String? = nil,
        page: Int
    ) -> Single<Page<[Product]>?> {
        let request = ObtainProductsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            search: search,
            folderId: folderId,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Product.map(response: $0) }
    }
    
    func delete(id: String) -> Single<RequestResult> {
        let request = DeleteProductRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                ProductsMediator.shared.notifyDeleteProduct(id: id)
            })
    }
    
    func duplicate(id: String) -> Single<RequestResult> {
        let request = DuplicateProductRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                ProductsMediator.shared.notifyDuplicateProduct()
            })
    }
}
