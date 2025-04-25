//
//  Product.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Foundation

struct Product {
    let id: String
    let title: String
    let image: URL
    let count: Int
    let barcode: String
    let folderId: String?
}

// MARK: Public
extension Product {
    static func map(response: Any) -> Page<[Product]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let items = body["items"] as? [[String: Any]],
            let pageInfoJSON = body["pagination"] as? [String: Any],
            let pageInfo = PageInfo(json: pageInfoJSON)
        else { return nil }
        
        let products = items.compactMap { Product(json: $0) }
        
        return Page(info: pageInfo, elements: products)
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let title = json["title"] as? String,
            let image: URL = {
                guard let string = json["image"] as? String else { return nil }
                return URL(string: string)
            }(),
            let count = json["count"] as? Int,
            let barcode = json["barcode"] as? String
        else { return nil }
        
        self.id = id
        self.title = title
        self.image = image
        self.count = count
        self.barcode = barcode
        self.folderId = json["folder"] as? String
    }
}
