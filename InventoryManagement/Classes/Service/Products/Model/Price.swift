//
//  Price.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

struct Price {
    let value: Double
    let currency: String
}

// MARK: Public
extension Price {
    init?(json: [String: Any]) {
        guard
            let value = json["value"] as? Double,
            let currency = json["currency"] as? String
        else { return nil }
        
        self.value = value
        self.currency = currency
    }
}
