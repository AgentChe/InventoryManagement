//
//  ItemsTableElement.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

enum ItemsTableElement {
    case addFirst
    case unlockAccess
    case title
    case block(ITBlockTitleElement)
    case demoProduct(DemoProduct)
    case statistics(Statistics)
    case folders([Folder])
    case lastAdded([Product])
    case product(Product)
}

struct ITBlockTitleElement {
    enum Block {
        case demoItems
        case folders
        case lastAdded
        case allItems
    }
    
    let block: Block
    let seeAllHidden: Bool
}

struct DemoProduct {
    enum Product {
        case stanleyCup
        case vitaminC
    }
    
    let product: Product
    let title: String
    let countLocalized: String
    let barcode: String
    
    init(product: Product) {
        self.product = product
        self.title = {
            switch product {
            case .stanleyCup:
                return "DemoProduct.StanleyCup.Title".localized
            case .vitaminC:
                return "DemoProduct.VitaminC.Title".localized
            }
        }()
        self.countLocalized = {
            switch product {
            case .stanleyCup:
                return "DemoProduct.StanleyCup.Count".localized
            case .vitaminC:
                return "DemoProduct.VitaminC.Count".localized
            }
        }()
        self.barcode = {
            switch product {
            case .stanleyCup:
                return "SH5XT0003"
            case .vitaminC:
                return "XX5UR5423"
            }
        }()
    }
}
