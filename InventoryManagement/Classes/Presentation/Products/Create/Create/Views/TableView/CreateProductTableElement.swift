//
//  CreateProductTableElement.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import Foundation

enum CreateProductTableElement {
    case general(CPTableGeneralElement)
}

struct CPTableGeneralElement {
    let photos: [CPPhotosCollectionElement]
    let selectedPhoto: URL?
    let title: String?
    let count: Int?
    let priceValue: Double?
    let priceCurrency: PriceCurrency
}
