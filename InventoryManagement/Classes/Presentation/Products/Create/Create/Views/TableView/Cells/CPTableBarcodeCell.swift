//
//  CPTableBarcodeCell.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import UIKit

final class CPTableBarcodeCell: UITableViewCell {
    lazy var barcodeView = makeImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CPTableBarcodeCell {
    func setup(barcode: Barcode) {
        DispatchQueue.global().async {
            let image = BarcodeImageGenerator().generate(from: barcode)
            
            DispatchQueue.main.async { [weak self] in
                self?.barcodeView.image = image
            }
        }
    }
}

// MARK: Private
private extension CPTableBarcodeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CPTableBarcodeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            barcodeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            barcodeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            barcodeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale),
            barcodeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            barcodeView.heightAnchor.constraint(equalToConstant: 100.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CPTableBarcodeCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
