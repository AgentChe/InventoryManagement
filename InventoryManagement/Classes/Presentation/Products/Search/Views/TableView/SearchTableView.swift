//
//  SearchTableView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchTableView: UITableView {
    private lazy var elements = [Product]()
    
    private lazy var didTapMenuTrigger = PublishRelay<Product>()
    private lazy var didSelectTrigger = PublishRelay<Product>()
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
extension SearchTableView {
    func setup(elements: [Product]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapMenu: Signal<Product> {
        didTapMenuTrigger.asSignal()
    }
    
    var didSelect: Signal<Product> {
        didSelectTrigger.asSignal()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SearchTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withIdentifier: String(describing: SearchTableCell.self), for: indexPath) as! SearchTableCell
        cell.setup(element: elements[indexPath.row])
        cell.didTapMenu = { [weak self] in
            self?.didTapMenuTrigger.accept(element)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension SearchTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        didSelectTrigger.accept(element)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        
        didScrollToBottomTrigger.accept(Void())
    }
}

// MARK: Private
private extension SearchTableView {
    func initialize() {
        register(SearchTableCell.self, forCellReuseIdentifier: String(describing: SearchTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
