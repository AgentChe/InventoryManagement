//
//  ProductDetails.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Foundation

struct ProductDetails {
    let title: String
    let images: [URL]
    let count: Int
    let barcode: String
    let price: Price
    let meta: [ProductMetaField]
}

// MARK: Public
extension ProductDetails {
    static func map(response: Any) -> ProductDetails? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let title = body["title"] as? String,
            let images: [URL] = {
                guard let strings = body["images"] as? [String] else { return [] }
                return strings.compactMap { URL(string: $0) }
            }(),
            let count = body["count"] as? Int,
            let barcode = body["barcode"] as? String,
            let price: Price = {
                guard let json = body["price"] as? [String: Any] else { return nil }
                return Price(json: json)
            }()
        else { return nil }
        
        return ProductDetails(
            title: title,
            images: images,
            count: count,
            barcode: barcode,
            price: price,
            meta: {
                guard let json = body["meta"] as? [String: Any] else { return [] }
                return ProductMetaFieldsMapper().fields(json: json)
            }()
        )
    }
}
