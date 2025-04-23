//
//  FoldersMediator.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import RxSwift
import RxCocoa

final class FoldersMediator {
    typealias Moved = (productId: String, fromFolderId: String, intoFolderId: String)
    
    static let shared = FoldersMediator()
    
    private lazy var didCreatedTrigger = PublishRelay<Void>()
    private lazy var didChangedTrigger = PublishRelay<String>()
    private lazy var didRenamedTrigger = PublishRelay<Folder>()
    private lazy var didDeletedTrigger = PublishRelay<String>()
    private lazy var didMovedProductIdTrigger = PublishRelay<Moved>()
    
    private init() {}
}

// MARK: Public
extension FoldersMediator {
    func notifyCreated() {
        didCreatedTrigger.accept(Void())
    }
    
    func notifyChanged(id: String) {
        didChangedTrigger.accept(id)
    }
    
    func notifyRenamed(folder: Folder) {
        didRenamedTrigger.accept(folder)
    }
    
    func notifyDeleted(id: String) {
        didDeletedTrigger.accept(id)
    }
    
    func notifyMoved(moved: Moved) {
        didMovedProductIdTrigger.accept(moved)
    }
    
    var didCreated: Signal<Void> {
        didCreatedTrigger.asSignal()
    }
    
    var didChanged: Signal<String> {
        didChangedTrigger.asSignal()
    }
    
    var didRenamed: Signal<Folder> {
        didRenamedTrigger.asSignal()
    }
    
    var didDeleted: Signal<String> {
        didDeletedTrigger.asSignal()
    }
    
    var didMoved: Signal<Moved> {
        didMovedProductIdTrigger.asSignal()
    }
}
