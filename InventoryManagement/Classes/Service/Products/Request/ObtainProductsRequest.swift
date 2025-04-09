//
//  ObtainProductsRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Alamofire

struct ObtainProductsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let search: String?
    let folderId: String?
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/product/discover"
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
            "search": search ?? NSNull(),
            "folder_id": folderId ?? NSNull()
        ]
    }
}
