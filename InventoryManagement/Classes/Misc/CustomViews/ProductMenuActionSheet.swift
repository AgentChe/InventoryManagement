//
//  ProductMenuActionSheet.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 24.04.2025.
//

import UIKit

final class ProductMenuActionSheet {
    func actionSheet(
        product: Product,
        duplicate: @escaping (Product) -> Void,
        moveToFolder: @escaping (Product) -> Void,
        delete: @escaping (Product) -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let duplicateAction = UIAlertAction(title: "ProductMenu.Duplicate".localized, style: .default) { action in
            duplicate(product)
        }
        alert.addAction(duplicateAction)
        
        let moveToFolderAction = UIAlertAction(title: "ProductMenu.MoveToFolder".localized, style: .default) { action in
            moveToFolder(product)
        }
        alert.addAction(moveToFolderAction)
        
        let deleteAction = UIAlertAction(title: "Delete".localized, style: .default) { action in
            delete(product)
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert.addAction(cancelAction)
        
        return alert
    }
}
