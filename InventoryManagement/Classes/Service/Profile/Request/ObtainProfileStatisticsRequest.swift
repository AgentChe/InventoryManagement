//
//  ObtainProfileStatisticsRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 21.04.2025.
//

import Alamofire

struct ObtainProfileStatisticsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/profile/home"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: HTTPHeaders? {
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
