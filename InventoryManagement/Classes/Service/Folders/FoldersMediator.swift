//
//  FoldersMediator.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import RxSwift
import RxCocoa

final class FoldersMediator {
    static let shared = FoldersMediator()
    
    private lazy var didCreatedTrigger = PublishRelay<Folder>()
    private lazy var didChangedTrigger = PublishRelay<String>()
    private lazy var didRenamedTrigger = PublishRelay<Folder>()
    private lazy var didDeletedTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension FoldersMediator {
    func notifyCreated(folder: Folder) {
        didCreatedTrigger.accept(folder)
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
    
    var didCreated: Signal<Folder> {
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
}
