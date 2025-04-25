//
//  FolderMoveRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import Alamofire

struct FolderMoveRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let targetFolderId: String
    let productId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/folder/move"
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
            "target_folder_id": targetFolderId,
            "product_id": productId
        ]
    }
}
