//
//  SMFTableView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SMFTableView: UITableView {
    private lazy var elements = [SMFTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SMFTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SMFTableView {
    func setup(elements: [SMFTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SMFTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SMFTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SMFTableCell.self), for: indexPath) as! SMFTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SMFTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SMFTableView {
    func initialize() {
        register(SMFTableCell.self, forCellReuseIdentifier: String(describing: SMFTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
