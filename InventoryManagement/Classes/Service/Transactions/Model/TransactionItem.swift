//
//  TransactionItem.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import Foundation

struct TransactionItem {
    let id: String
    let type: String
    let date: Date
    let productId: String?
    let folderId: String?
    let title: String
    let barcode: String
    let count: Int
}

// MARK: Public
extension TransactionItem {
    static func map(response: Any) -> Page<[TransactionItem]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let itemsArray = body["items"] as? [[String: Any]],
            let pageInfoJSON = body["pagination"] as? [String: Any],
            let pageInfo = PageInfo(json: pageInfoJSON)
        else { return nil }
        
        let items = itemsArray.compactMap { TransactionItem(json: $0) }
        
        return Page(info: pageInfo, elements: items)
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let type = json["transaction_type"] as? String,
            let timestamp = json["transaction_date"] as? TimeInterval,
            let productId = json["product_id"] as? String,
            let title = json["title"] as? String,
            let barcode = json["barcode"] as? String,
            let count = json["count"] as? Int
        else { return nil }
        
        self.id = id
        self.type = type
        self.date = Date(timeIntervalSince1970: timestamp / 1000)
        self.productId = productId
        self.folderId = json["folder"] as? String
        self.title = title
        self.barcode = barcode
        self.count = count
    }
}
