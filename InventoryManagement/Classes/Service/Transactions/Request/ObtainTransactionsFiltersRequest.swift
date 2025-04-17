//
//  ObtainTransactionsFiltersRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import Alamofire

struct ObtainTransactionsFiltersRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/transactions/filter"
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
            "internal_id": internalId
        ]
    }
}
