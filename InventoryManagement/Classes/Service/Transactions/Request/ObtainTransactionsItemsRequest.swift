//
//  ObtainTransactionsItemsRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import Alamofire

struct ObtainTransactionsItemsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let filters: [String]?
    let sort: String?
    let foldersIds: [String]?
    let page: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/transactions/search"
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
            "transaction_types": filters ?? NSNull(),
            "sort_by": sort ?? NSNull(),
            "folder_ids": foldersIds ?? NSNull(),
            "page": page
        ]
    }
}
