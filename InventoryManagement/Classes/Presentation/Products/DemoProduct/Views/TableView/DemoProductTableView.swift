//
//  DemoProductTableView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 24.04.2025.
//

import UIKit

final class DemoProductTableView: UITableView {
    weak var vc: UIViewController?
    
    private lazy var elements = [DemoProductTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension DemoProductTableView {
    func setup(elements: [DemoProductTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension DemoProductTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .general(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: DPTableGeneralCell.self), for: indexPath) as! DPTableGeneralCell
            cell.setup(element: element)
            return cell
        case .barcode(let barcode):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CPTableBarcodeCell.self), for: indexPath) as! CPTableBarcodeCell
            cell.setup(barcode: barcode)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension DemoProductTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension DemoProductTableView {
    func initialize() {
        register(DPTableGeneralCell.self, forCellReuseIdentifier: String(describing: DPTableGeneralCell.self))
        register(CPTableBarcodeCell.self, forCellReuseIdentifier: String(describing: CPTableBarcodeCell.self))
        dataSource = self
        delegate = self
    }
}
