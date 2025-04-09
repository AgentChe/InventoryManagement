//
//  CreateFolderRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Alamofire

struct CreateFolderRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let title: String
    let notes: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/folder/create"
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
            "notes": notes ?? NSNull()
        ]
    }
}
