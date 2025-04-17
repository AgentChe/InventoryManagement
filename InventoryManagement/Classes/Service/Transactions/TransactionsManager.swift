//
//  TransactionsManager.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import RxSwift

protocol TransactionsManagerProtocol {
    func obtainFilters() -> Single<TransactionsFilters?>
    func obtainItems(
        filters: [String]?,
        sort: String?,
        foldersIds: [String]?,
        page: Int
    ) -> Single<Page<[TransactionItem]>?>
}

final class TransactionsManager {
    private lazy var restAPITransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: TransactionsManagerProtocol
extension TransactionsManager: TransactionsManagerProtocol {
    func obtainFilters() -> Single<TransactionsFilters?> {
        let request = ObtainTransactionsFiltersRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { TransactionsFilters(response: $0) }
    }
    
    func obtainItems(
        filters: [String]? = nil,
        sort: String? = nil,
        foldersIds: [String]? = nil,
        page: Int
    ) -> Single<Page<[TransactionItem]>?> {
        let request = ObtainTransactionsItemsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            filters: filters,
            sort: sort,
            foldersIds: foldersIds,
            page: page
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { TransactionItem.map(response: $0) }
    }
}
