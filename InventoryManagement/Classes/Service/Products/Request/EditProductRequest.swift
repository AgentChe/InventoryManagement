//
//  EditProductRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import Alamofire

struct EditProductRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    let title: String
    let images: [String]
    let count: Int
    let barcode: String
    let priceValue: Double
    let priceCurrency: String
    let meta: [String: Any]?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/product/edit"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: Alamofire.HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId,
            "product_id": id,
            "title": title,
            "images": images,
            "count": count,
            "barcode": barcode,
            "price": [
                "value": priceValue,
                "currency": priceCurrency
            ],
            "meta": meta ?? NSNull()
        ]
    }
}
