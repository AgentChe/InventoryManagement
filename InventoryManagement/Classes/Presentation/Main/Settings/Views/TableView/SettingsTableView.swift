//
//  SettingsTableView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 08.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsTableView: UITableView {
    private lazy var elements = [SettingsTableElement]()
    
    private lazy var didTapUnlockAccessTrigger = PublishRelay<Void>()
    private lazy var didTapLinkTrigger = PublishRelay<STLinkButton.Link>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsTableView {
    func setup(elements: [SettingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapUnlockAccess: Signal<Void> {
        didTapUnlockAccessTrigger.asSignal()
    }
    
    var didTapLink: Signal<STLinkButton.Link> {
        didTapLinkTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .unlockAccess:
            let cell = dequeueReusableCell(withIdentifier: String(describing: STUnlockAccessCell.self), for: indexPath) as! STUnlockAccessCell
            cell.didTapUnlock = { [weak self] in
                self?.didTapUnlockAccessTrigger.accept(Void())
            }
            return cell
        case .links:
            let cell = dequeueReusableCell(withIdentifier: String(describing: STLinksCell.self), for: indexPath) as! STLinksCell
            cell.didTapLink = { [weak self] link in
                self?.didTapLinkTrigger.accept(link)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        dataSource = self
        delegate = self
        
        register(STUnlockAccessCell.self, forCellReuseIdentifier: String(describing: STUnlockAccessCell.self))
        register(STLinksCell.self, forCellReuseIdentifier: String(describing: STLinksCell.self))
    }
}
