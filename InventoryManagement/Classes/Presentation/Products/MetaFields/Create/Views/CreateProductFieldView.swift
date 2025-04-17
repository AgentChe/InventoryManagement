//
//  CreateProductFieldView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit

class CreateProductFieldView: UIView {
    var didChangeEnable: ((Bool) -> Void)?
    
    func forceCheckEnable() {
        fatalError("Should be override")
    }
}
