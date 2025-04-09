//
//  CreateProductRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Alamofire

struct CreateProductRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let title: String
    let images: [String]
    let count: Int
    let barcode: String
    let priceValue: Double
    let priceCurrency: String
    let meta: [String: Any]?
    let relate: [String: Any]?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/product/create"
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
            "title": title,
            "images": images,
            "count": count,
            "barcode": barcode,
            "price": [
                "value": priceValue,
                "currency": priceCurrency
            ],
            "meta": meta ?? NSNull(),
            "relate": relate ?? NSNull()
        ]
    }
}
