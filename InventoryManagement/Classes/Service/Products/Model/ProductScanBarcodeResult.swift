//
//  ProductScanBarcodeResult.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import Foundation

struct ProductScanBarcodeResult {
    let title: String
    let images: [URL]
    let price: Price?
    let barcode: String
    let relate: [String: Any]?
}

// MARK: Public
extension ProductScanBarcodeResult {
    static func map(response: Any) -> ProductScanBarcodeResult? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let title = body["title"] as? String,
            let images: [URL] = {
                guard let string = body["images"] as? [String] else { return [] }
                return string.compactMap { URL(string: $0) }
            }(),
            let barcode = body["barcode"] as? String
        else { return nil }
        
        let price: Price? = {
            guard let json = body["price"] as? [String: Any] else { return nil }
            return Price(json: json)
        }()
        
        return ProductScanBarcodeResult(
            title: title,
            images: images,
            price: price,
            barcode: barcode,
            relate: body["relate"] as? [String: Any]
        )
    }
}
