//
//  DeleteFolderRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Alamofire

struct DeleteFolderRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let id: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/folder/delete"
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
            "folder_id": id
        ]
    }
}
