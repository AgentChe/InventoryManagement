//
//  PageInfo.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

struct PageInfo {
    let current: Int
    let next: Int
    let total: Int
}

// MARK: Public
extension PageInfo {
    init?(json: [String: Any]) {
        guard
            let current = json["current"] as? Int,
            let next = json["next"] as? Int,
            let total = json["total"] as? Int
        else { return nil }
        
        self.current = current
        self.next = next
        self.total = total
    }
}
