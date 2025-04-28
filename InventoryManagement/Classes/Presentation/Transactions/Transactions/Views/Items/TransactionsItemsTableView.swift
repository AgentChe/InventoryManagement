//
//  TransactionsItemsTableView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 28.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class TransactionsItemsTableView: UITableView {
    private lazy var elements = [TransactionItem]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TransactionsItemsTableView {
    func setup(elements: [TransactionItem]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension TransactionsItemsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: TransactionsItemsTableCell.self), for: indexPath) as! TransactionsItemsTableCell
        cell.setup(item: elements[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        
        didScrollToBottomTrigger.accept(Void())
    }
}

// MARK: UITableViewDataSource
extension TransactionsItemsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension TransactionsItemsTableView {
    func initialize() {
        register(TransactionsItemsTableCell.self, forCellReuseIdentifier: String(describing: TransactionsItemsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
