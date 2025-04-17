//
//  CreateProductAssembly.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import UIKit

final class CreateProductAssembly {
    // TODO
    func scan(from: UIViewController) {
        manually(from: from)
        
//        let nc = NavigationController()
//        nc.modalPresentationStyle = .fullScreen
//        
//        let scanVC = ScannerViewController.make { [weak nc] code in
//            let createVC = CreateProductViewController.make(source: .scan(code))
//            nc?.setViewControllers([createVC], animated: true)
//        }
//        nc.setViewControllers([scanVC], animated: false)
//        
//        from.present(nc, animated: true)
    }
    
    func manually(from: UIViewController) {
        let nc = NavigationController()
        nc.modalPresentationStyle = .fullScreen
        
        let createVC = CreateProductViewController.make(source: .manually)
        nc.setViewControllers([createVC], animated: true)
        
        from.present(nc, animated: true)
    }
    
    func edit(from: UIViewController, product: Product) {
        let nc = NavigationController()
        nc.modalPresentationStyle = .fullScreen
        
        let createVC = CreateProductViewController.make(source: .edit(product))
        nc.setViewControllers([createVC], animated: true)
        
        from.present(nc, animated: true)
    }
}
