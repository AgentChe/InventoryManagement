//
//  TransactionsManager.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 16.04.2025.
//

import RxSwift

protocol TransactionsManagerProtocol {
    func obtainFilters(forceUpdate: Bool) -> Single<TransactionsFilters?>
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
    func obtainFilters(forceUpdate: Bool) -> Single<TransactionsFilters?> {
        forceUpdate ? downloadFilters() : cachedFilters()
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

// MARK: Private
private extension TransactionsManager {
    enum Constants {
        static let filtersKey = "transactions_manager_filters_key"
    }
    
    func downloadFilters() -> Single<TransactionsFilters?> {
        let request = ObtainTransactionsFiltersRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { TransactionsFilters(response: $0) }
            .do(onSuccess: { filters in
                guard let filters, let data = try? JSONEncoder().encode(filters) else { return }
                
                UserDefaults.standard.set(data, forKey: Constants.filtersKey)
            })
    }
        
    func cachedFilters() -> Single<TransactionsFilters?> {
        Single<TransactionsFilters?>.create { single in
            let filters: TransactionsFilters? = {
                guard let data = UserDefaults.standard.data(forKey: Constants.filtersKey) else { return nil }
                return try? JSONDecoder().decode(TransactionsFilters.self, from: data)
            }()
            
            single(.success(filters))
            
            return Disposables.create()
        }
    }
}
