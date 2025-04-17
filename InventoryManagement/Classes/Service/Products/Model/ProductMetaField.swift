//
//  ProductMetaField.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 17.04.2025.
//

import Foundation

final class ProductMetaFieldsMapper {
    func fields(json: [String: Any]) -> [ProductMetaField] {
        var fields = [ProductMetaField]()
        
        json.forEach { key, value in
            let array = value as? [[String: Any]] ?? []
            
            switch key {
            case FieldsKeys.smallTextBoxKey:
                let items = array.compactMap { SmallTextBoxField(json: $0) }
                fields.append(contentsOf: items)
            case FieldsKeys.largeTextBoxKey:
                let items = array.compactMap { LargeTextBoxField(json: $0) }
                fields.append(contentsOf: items)
            case FieldsKeys.roundNumberKey:
                let items = array.compactMap { RoundNumberField(json: $0) }
                fields.append(contentsOf: items)
            case FieldsKeys.decimalNumberKey:
                let items = array.compactMap { DecimalNumberField(json: $0) }
                fields.append(contentsOf: items)
            case FieldsKeys.checkboxKey:
                let items = array.compactMap { CheckboxField(json: $0) }
                fields.append(contentsOf: items)
            case FieldsKeys.dateKey:
                let items = array.compactMap { DateField(json: $0) }
                fields.append(contentsOf: items)
            case FieldsKeys.phoneNumberKey:
                let items = array.compactMap { PhoneNumberField(json: $0) }
                fields.append(contentsOf: items)
            case FieldsKeys.webLinkKey:
                let items = array.compactMap { WebLinkField(json: $0) }
                fields.append(contentsOf: items)
            case FieldsKeys.emailKey:
                let items = array.compactMap { EmailField(json: $0) }
                fields.append(contentsOf: items)
            default:
                break
            }
        }
        
        return fields
    }
    
    func json(fields: [ProductMetaField]) -> [String: Any] {
        Dictionary(grouping: fields, by: \.key)
            .mapValues { $0.map { $0.toJSON() } }
            .reduce(into: [String: Any]()) { $0[$1.key] = $1.value }
    }
}

protocol ProductMetaField {
    init?(json: [String: Any])
    var id: String { get }
    var name: String { get }
    var key: String { get }
    func toJSON() -> [String: Any]
}

// MARK: SmallTextBox
struct SmallTextBoxField: ProductMetaField {
    let id: String
    let name: String
    let text: String?
    let key = FieldsKeys.smallTextBoxKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        text: String?
    ) {
        self.id = id
        self.name = name
        self.text = text
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.text = json["text"] as? String
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "text": text ?? NSNull()
        ]
    }
}

// MARK: LargeTextBox
struct LargeTextBoxField: ProductMetaField {
    let id: String
    let name: String
    let text: String?
    let key = FieldsKeys.largeTextBoxKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        text: String?
    ) {
        self.id = id
        self.name = name
        self.text = text
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.text = json["text"] as? String
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "text": text ?? NSNull()
        ]
    }
}

// MARK: RoundNumber
struct RoundNumberField: ProductMetaField {
    let id: String
    let name: String
    let number: Int?
    let key = FieldsKeys.roundNumberKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        number: Int?
    ) {
        self.id = id
        self.name = name
        self.number = number
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.number = json["number"] as? Int
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "number": number ?? NSNull()
        ]
    }
}

// MARK: DecimalNumber
struct DecimalNumberField: ProductMetaField {
    let id: String
    let name: String
    let number: Double?
    let key = FieldsKeys.decimalNumberKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        number: Double?
    ) {
        self.id = id
        self.name = name
        self.number = number
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.number = json["number"] as? Double
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "number": number ?? NSNull()
        ]
    }
}

// MARK: DecimalNumber
struct CheckboxField: ProductMetaField {
    let id: String
    let name: String
    let value: Bool?
    let key = FieldsKeys.checkboxKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        value: Bool?
    ) {
        self.id = id
        self.name = name
        self.value = value
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let value = json["value"] as? Bool
        else { return nil }
        
        self.id = id
        self.name = name
        self.value = value
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "value": value ?? NSNull()
        ]
    }
}

// MARK: Date
struct DateField: ProductMetaField {
    let id: String
    let name: String
    let date: Date?
    let key = FieldsKeys.dateKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        date: Date?
    ) {
        self.id = id
        self.name = name
        self.date = date
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.date = {
            guard let timestamp = json["date"] as? TimeInterval else { return nil }
            return Date(timeIntervalSince1970: timestamp)
        }()
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "date": date?.timeIntervalSince1970 ?? NSNull()
        ]
    }
}

// MARK: PhoneNumber
struct PhoneNumberField: ProductMetaField {
    let id: String
    let name: String
    let phoneNumber: String?
    let key = FieldsKeys.phoneNumberKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        phoneNumber: String?
    ) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.phoneNumber = json["phone_number"] as? String
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "phone_number": phoneNumber ?? NSNull()
        ]
    }
}

// MARK: WebLink
struct WebLinkField: ProductMetaField {
    let id: String
    let name: String
    let link: String?
    let key = FieldsKeys.webLinkKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        link: String?
    ) {
        self.id = id
        self.name = name
        self.link = link
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.link = json["link"] as? String
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "link": link ?? NSNull()
        ]
    }
}

// MARK: Email
struct EmailField: ProductMetaField {
    let id: String
    let name: String
    let email: String?
    let key = FieldsKeys.emailKey
    
    init(
        id: String = UUID().uuidString,
        name: String,
        email: String?
    ) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String
        else { return nil }
        
        self.id = id
        self.name = name
        self.email = json["email"] as? String
    }
    
    func toJSON() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "email": email ?? NSNull()
        ]
    }
}

private enum FieldsKeys {
    static let smallTextBoxKey = "small_text_box"
    static let largeTextBoxKey = "large_text_box"
    static let roundNumberKey = "round_number"
    static let decimalNumberKey = "decimal_number"
    static let checkboxKey = "checkbox"
    static let dateKey = "date"
    static let phoneNumberKey = "phone_number"
    static let webLinkKey = "web_link"
    static let emailKey = "email"
}
