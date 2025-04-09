//
//  ObtainFoldersRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Alamofire

struct ObtainFoldersRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/folder/list"
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
            "page": page
        ]
    }
}
