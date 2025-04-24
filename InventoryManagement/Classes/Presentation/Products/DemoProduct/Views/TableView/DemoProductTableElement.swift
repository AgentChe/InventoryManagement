//
//  DemoProductTableElement.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 24.04.2025.
//

import Foundation

enum DemoProductTableElement {
    case general(DPTableGeneralElement)
    case barcode(Barcode)
}

struct DPTableGeneralElement {
    let photoName: String
    let title: String?
    let count: Int?
    let priceValue: Double?
    let priceCurrency: PriceCurrency
}
