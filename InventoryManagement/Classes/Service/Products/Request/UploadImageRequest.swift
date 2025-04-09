//
//  UploadImageRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Alamofire

struct UploadImageRequest: APIFormDataRequestBody {
    let anonymousId: String
    let internalId: String
    let image: UIImage
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/product/image"
    }
    
    var parameters: [String : Data]? {
        var parameters = [String: Data]()
        
        if let anonymousId = anonymousId.data(using: .utf8) {
            parameters["anonymous_id"] = anonymousId
        }
        
        if let internalId = internalId.data(using: .utf8) {
            parameters["internal_id"] = internalId
        }
        
        return parameters
    }
    
    var headers: Alamofire.HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
}
