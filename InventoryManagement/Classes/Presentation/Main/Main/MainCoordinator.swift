//
//  MainCoordinator.swift
//  SmartCloset
//
//  Created by Андрей Чернышев on 29.01.2025.
//

import UIKit

final class MainCoordinator {
    private lazy var itemsVC = UIViewController()
    private lazy var transactionsVC = UIViewController()
    private lazy var searchVC = UIViewController()
    private lazy var settingsVC = SettingsViewController.make()
    
    private weak var parentVC: UIViewController?
    private weak var container: UIView?
    
    private var previousVC: UIViewController?
    
    init(parentVC: UIViewController, container: UIView) {
        self.parentVC = parentVC
        self.container = container
    }
}

// MARK: Public
extension MainCoordinator {
    func change(tab: TabView.Tab) {
        switch tab {
        case .items:
            changeVC(on: itemsVC)
        case .transactions:
            changeVC(on: transactionsVC)
        case .add:
            return
        case .search:
            changeVC(on: searchVC)
        case .settings:
            changeVC(on: settingsVC)
        }
    }
}

// MARK: Private
private extension MainCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC, let container else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = container.bounds
        container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
