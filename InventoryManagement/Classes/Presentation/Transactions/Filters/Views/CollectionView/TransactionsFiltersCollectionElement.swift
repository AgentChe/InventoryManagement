//
//  TransactionsFiltersCollectionElement.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 27.04.2025.
//

enum TransactionsFiltersCollectionElement {
    case transactionTypesTitle
    case transactionType(TransactionsFiltersTypeElement)
    case sort(String)
}

final class TransactionsFiltersTypeElement {
    let type: String
    var selected: Bool
    
    init(type: String, selected: Bool) {
        self.type = type
        self.selected = selected
    }
}
