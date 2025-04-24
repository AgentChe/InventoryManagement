//
//  ProfileStatistics.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 21.04.2025.
//

struct ProfileStatistics {
    let lastAddedProducts: [Product]
    let statistics: Statistics
    
    // TODO
    init?(response: Any) {
        return nil
//        guard
//            let json = response as? [String: Any],
//            let body = json["body"] as? [String: Any],
//            let productsArray = body["last_added"] as? [[String: Any]],
//            let statisticsJSON = body["statistics"] as? [String: Any],
//            let statistics = Statistics(json: statisticsJSON)
//        else { return nil }
//        
//        self.lastAddedProducts = productsArray.compactMap { Product(json: $0) }
//        self.statistics = statistics
    }
}

struct Statistics {
    let productsCount: Int
    let foldersCount: Int
    let totalPrice: Price
    let totalQTY: Int
    
    init(
        productsCount: Int = 0,
        foldersCount: Int = 0,
        totalPrice: Price = Price(value: 0, currency: .dollar),
        totalQTY: Int = 0
    ) {
        self.productsCount = productsCount
        self.foldersCount = foldersCount
        self.totalPrice = totalPrice
        self.totalQTY = totalQTY
    }
    
    init?(json: [String: Any]) {
        guard
            let productsCount = json["items"] as? Int,
            let foldersCount = json["folders"] as? Int,
            let priceJSON = json["total_value"] as? [String: Any],
            let price = Price(json: priceJSON),
            let totalQTY = json["total_qty"] as? Int
        else { return nil }
        
        self.productsCount = productsCount
        self.foldersCount = foldersCount
        self.totalPrice = price
        self.totalQTY = totalQTY
    }
}
