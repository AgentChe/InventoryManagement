//
//  ManageFolderRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Alamofire

struct ManageFolderRequest: APIRequestBody {
    enum Action {
        case remove, add
    }
    
    let anonymousId: String
    let internalId: String
    let folderId: String
    let productsIds: [String]
    let action: Action
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/folder/group"
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
            "folder_id": folderId,
            "products": productsIds,
            "remove": {
                switch action {
                case .add:
                    return false
                case .remove:
                    return true
                }
            }()
        ]
    }
}
