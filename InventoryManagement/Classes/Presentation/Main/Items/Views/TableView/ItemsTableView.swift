//
//  ItemsTableView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 22.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemsTableView: UITableView {
    private lazy var elements = [ItemsTableElement]()
    
    private lazy var didTapAddFirstItemTrigger = PublishRelay<Void>()
    private lazy var didTapUnlockAccessTrigger = PublishRelay<Void>()
    private lazy var didSelectDemoProductTrigger = PublishRelay<DemoProduct>()
    private lazy var didSelectFolderTrigger = PublishRelay<Folder>()
    private lazy var didTapAddNewFolderTrigger = PublishRelay<Void>()
    private lazy var didSelectProductTrigger = PublishRelay<Product>()
    private lazy var didTapProductMenuTrigger = PublishRelay<Product>()
    private lazy var didTapSeeAllBlockTrigger = PublishRelay<ITBlockTitleElement.Block>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ItemsTableView {
    func setup(elements: [ItemsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapAddFirstItem: Signal<Void> {
        didTapAddFirstItemTrigger.asSignal()
    }
    
    var didTapUnlockAccess: Signal<Void> {
        didTapUnlockAccessTrigger.asSignal()
    }
    
    var didSelectDemoProduct: Signal<DemoProduct> {
        didSelectDemoProductTrigger.asSignal()
    }
    
    var didSelectFolder: Signal<Folder> {
        didSelectFolderTrigger.asSignal()
    }
    
    var didTapAddNewFolder: Signal<Void> {
        didTapAddNewFolderTrigger.asSignal()
    }
    
    var didSelectProduct: Signal<Product> {
        didSelectProductTrigger.asSignal()
    }
    
    var didTapProductMenu: Signal<Product> {
        didTapProductMenuTrigger.asSignal()
    }
    
    var didTapSeeAllBlock: Signal<ITBlockTitleElement.Block> {
        didTapSeeAllBlockTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ItemsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .addFirst:
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITAddFirstCell.self), for: indexPath) as! ITAddFirstCell
            cell.didTapAdd = { [weak self] in
                self?.didTapAddFirstItemTrigger.accept(Void())
            }
            return cell
        case .unlockAccess:
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITUnlockAccessCell.self), for: indexPath) as! ITUnlockAccessCell
            cell.didTap = { [weak self] in
                self?.didTapUnlockAccessTrigger.accept(Void())
            }
            return cell
        case .title:
            return dequeueReusableCell(withIdentifier: String(describing: ITTitleCell.self), for: indexPath)
        case .block(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITBlockTitleCell.self), for: indexPath) as! ITBlockTitleCell
            cell.setup(element: element)
            cell.didTap = { [weak self] in
                self?.didTapSeeAllBlockTrigger.accept(element.block)
            }
            return cell
        case .demoProduct(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITDemoProductCell.self), for: indexPath) as! ITDemoProductCell
            cell.setup(element: element)
            return cell
        case .statistics(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITStatisticsCell.self), for: indexPath) as! ITStatisticsCell
            cell.setup(element: element)
            return cell
        case .folders(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITFoldersCell.self), for: indexPath) as! ITFoldersCell
            cell.collectionView.setup(folders: elements)
            cell.collectionView.didSelect = { [weak self] folder in
                self?.didSelectFolderTrigger.accept(folder)
            }
            cell.collectionView.didTapAddNew = { [weak self] in
                self?.didTapAddNewFolderTrigger.accept(Void())
            }
            return cell
        case .lastAdded(let elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITLastAddedCell.self), for: indexPath) as! ITLastAddedCell
            cell.collectionView.setup(elements: elements)
            cell.collectionView.didSelect = { [weak self] product in
                self?.didSelectProductTrigger.accept(product)
            }
            cell.collectionView.didTapMenu = { [weak self] product in
                self?.didTapProductMenuTrigger.accept(product)
            }
            return cell
        case .product(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ITProductCell.self), for: indexPath) as! ITProductCell
            cell.setup(element: element)
            cell.didTapMenu = { [weak self] in
                self?.didTapProductMenuTrigger.accept(element)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ItemsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .product(let product):
            didSelectProductTrigger.accept(product)
        default:
            return
        }
    }
}

// MARK: Private
private extension ItemsTableView {
    func initialize() {
        register(ITAddFirstCell.self, forCellReuseIdentifier: String(describing: ITAddFirstCell.self))
        register(ITUnlockAccessCell.self, forCellReuseIdentifier: String(describing: ITUnlockAccessCell.self))
        register(ITTitleCell.self, forCellReuseIdentifier: String(describing: ITTitleCell.self))
        register(ITBlockTitleCell.self, forCellReuseIdentifier: String(describing: ITBlockTitleCell.self))
        register(ITDemoProductCell.self, forCellReuseIdentifier: String(describing: ITDemoProductCell.self))
        register(ITStatisticsCell.self, forCellReuseIdentifier: String(describing: ITStatisticsCell.self))
        register(ITFoldersCell.self, forCellReuseIdentifier: String(describing: ITFoldersCell.self))
        register(ITLastAddedCell.self, forCellReuseIdentifier: String(describing: ITLastAddedCell.self))
        register(ITProductCell.self, forCellReuseIdentifier: String(describing: ITProductCell.self))
        
        dataSource = self
        delegate = self
    }
}
