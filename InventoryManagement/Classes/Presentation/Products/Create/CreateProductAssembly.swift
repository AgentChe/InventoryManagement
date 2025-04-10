//
//  CreateProductAssembly.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import UIKit

final class CreateProductAssembly {
    func scan(from: UIViewController) {
        let nc = NavigationController()
        nc.modalPresentationStyle = .fullScreen
        
        let scanVC = ScannerViewController.make { [weak nc] code in
            print(code)
        }
        nc.setViewControllers([scanVC], animated: false)
        
        from.present(nc, animated: true)
    }
}
