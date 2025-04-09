//
//  UploadImageResult.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Foundation

struct UploadImageResult {
    let url: URL
}

// MARK: Public
extension UploadImageResult {
    static func map(response: Any) -> UploadImageResult? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let string = body["image_url"] as? String,
            let url = URL(string: string)
        else { return nil }
        
        return UploadImageResult(url: url)
    }
}
