//
//  CPPhotosCollectionElement.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import Foundation

enum CPPhotosCollectionElement {
    case photo(CPPCollectionPhotoElement)
    case add
}

struct CPPCollectionPhotoElement {
    let url: URL
    let selected: Bool
}
