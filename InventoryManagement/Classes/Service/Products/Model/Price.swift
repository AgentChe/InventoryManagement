//
//  Price.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

struct Price {
    let value: Double
    let currency: PriceCurrency
}

enum PriceCurrency {
    case dollar, euro
    
    enum Constants {
        static let dollar = "USD"
        static let euro = "EURO"
    }
    
    init?(rawValue: String) {
        switch rawValue {
        case Constants.dollar:
            self = .dollar
        case Constants.euro:
            self = .euro
        default:
            return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .dollar:
            return Constants.dollar
        case .euro:
            return Constants.euro
        }
    }
    
    var symbol: String {
        switch self {
        case .dollar:
            return "$"
        case .euro:
            return "€"
        }
    }
}

// MARK: Public
extension Price {
    init?(json: [String: Any]) {
        guard
            let value = json["value"] as? Double,
            let currency: PriceCurrency = {
                guard let rawValue = json["currency"] as? String else { return nil }
                return PriceCurrency(rawValue: rawValue)
            }()
        else { return nil }
        
        self.value = value
        self.currency = currency
    }
}
