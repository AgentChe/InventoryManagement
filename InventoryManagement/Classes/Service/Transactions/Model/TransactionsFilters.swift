//
//  TransactionsFilters.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

struct TransactionsFilters {
    let filters: [String]
    let sort: [String]
}

// MARK: Public
extension TransactionsFilters {
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let filters = body["filters"] as? [String],
            let sort = body["sort_by"] as? [String]
        else { return nil }
        
        self.filters = filters
        self.sort = sort
    }
}
