//
//  DuplicateProductRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 25.04.2025.
//

import Alamofire

struct DuplicateProductRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/product/duplicate"
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
