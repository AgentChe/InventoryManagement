//
//  FoldersManager.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

import RxSwift

protocol FoldersManagerProtocol {
    func create(title: String, notes: String?) -> Single<RequestResult>
    func obtain(page: Int) -> Single<Page<[Folder]>?>
    func manage(
        folderId: String,
        productsIds: [String],
        action: ManageFolderRequest.Action
    ) -> Single<RequestResult>
    func rename(id: String, title: String, notes: String?) -> Single<RequestResult>
    func delete(id: String) -> Single<RequestResult>
    func move(
        currentFolderId: String,
        targetFolderId: String,
        productId: String
    ) -> Single<RequestResult>
}

final class FoldersManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: FoldersManagerProtocol
extension FoldersManager: FoldersManagerProtocol {
    func create(title: String, notes: String?) -> Single<RequestResult> {
        let request = CreateFolderRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            title: title,
            notes: notes
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                FoldersMediator.shared.notifyCreated()
            })
    }
    
    func obtain(page: Int) -> Single<Page<[Folder]>?> {
        let request = ObtainFoldersRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Folder.map(listResponse: $0) }
    }
    
    func manage(
        folderId: String,
        productsIds: [String],
        action: ManageFolderRequest.Action
    ) -> Single<RequestResult> {
        let request = ManageFolderRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            folderId: folderId,
            productsIds: productsIds,
            action: action
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                FoldersMediator.shared.notifyChanged(id: folderId)
            })
    }
    
    func rename(id: String, title: String, notes: String?) -> Single<RequestResult> {
        let request = RenameFolderRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id,
            title: title,
            notes: notes
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                let folder = Folder(id: id, title: title, notes: notes)
                FoldersMediator.shared.notifyRenamed(folder: folder)
            })
    }
    
    func delete(id: String) -> Single<RequestResult> {
        let request = DeleteFolderRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                FoldersMediator.shared.notifyDeleted(id: id)
            })
    }
    
    func move(
        currentFolderId: String,
        targetFolderId: String,
        productId: String
    ) -> Single<RequestResult> {
        let request = FolderMoveRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            currentFolderId: currentFolderId,
            targetFolderId: targetFolderId,
            productId: productId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                let moved: FoldersMediator.Moved = (
                    productId: productId,
                    fromFolderId: currentFolderId,
                    intoFolderId: targetFolderId
                )
                FoldersMediator.shared.notifyMoved(moved: moved)
            })
    }
}
