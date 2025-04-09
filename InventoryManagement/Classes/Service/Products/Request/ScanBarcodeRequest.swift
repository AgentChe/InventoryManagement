//
//  ScanBarcodeRequest.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Alamofire

struct ScanBarcodeRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let barcode: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/product/scan"
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
            "barcode": barcode
        ]
    }
}
