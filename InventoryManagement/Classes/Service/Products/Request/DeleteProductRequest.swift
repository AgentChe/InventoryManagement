//
//  DeleteProductRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import Alamofire

struct DeleteProductRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/product/delete"
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
            "product_id": id
        ]
    }
}
