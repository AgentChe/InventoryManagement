//
//  Folder.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 09.04.2025.
//

struct Folder {
    let id: String
    let title: String
    let notes: String?
}

// MARK: Public
extension Folder {
    static func map(
        createResponse: Any,
        title: String,
        notes: String?
    ) -> Folder? {
        guard
            let json = createResponse as? [String: Any],
            let body = json["body"] as? [String: Any],
            let id = body["folder_id"] as? String
        else { return nil }
        
        return Folder(
            id: id,
            title: title,
            notes: notes
        )
    }
    
    static func map(listResponse: Any) -> Page<[Folder]>? {
        guard
            let json = listResponse as? [String: Any],
            let body = json["body"] as? [String: Any],
            let items = body["items"] as? [[String: Any]],
            let pageInfoJSON = body["pagination"] as? [String: Any],
            let pageInfo = PageInfo(json: pageInfoJSON)
        else { return nil }
            
        let folders = items.compactMap { json -> Folder? in
            guard
                let id = json["id"] as? String,
                let title = json["title"] as? String
            else { return nil }
            
            return Folder(
                id: id,
                title: title,
                notes: json["notes"] as? String
            )
        }
        
        return Page(info: pageInfo, elements: folders)
    }
}
