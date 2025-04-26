//
//  CreateProductTableElement.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 14.04.2025.
//

import Foundation

enum CreateProductTableElement {
    case general(CPTableGeneralElement)
    case addFields
    case barcode(Barcode)
    case addBarcode
    case save(Bool)
    case metaField(CPTableMetaFieldElement)
}

struct CPTableGeneralElement {
    let photos: [CPPhotosCollectionElement]
    let selectedPhoto: URL?
    let title: String?
    let count: Int?
    let priceValue: Double?
    let priceCurrency: PriceCurrency
}

enum CPTableMetaFieldElement {
    case smallTextBox(CPTSmallTextBoxFieldElement)
    case largeTextBox(CPTLargeTextBoxFieldElement)
    case roundNumber(CPTRoundNumberFieldElement)
    case decimalNumber(CPTDecimalNumberFieldElement)
    case checkBox(CPTCheckboxFieldElement)
    case date(CPTDateFieldElement)
    case phoneNumber(CPTPhoneNumberFieldElement)
    case webLink(CPTWebLinkFieldElement)
    case email(CPTEmailFieldElement)
}

final class CPTSmallTextBoxFieldElement {
    let id: String
    let name: String
    var text: String?
    
    init(field: SmallTextBoxField) {
        self.id = field.id
        self.name = field.name
        self.text = field.text
    }
}

final class CPTLargeTextBoxFieldElement {
    let id: String
    let name: String
    var text: String?
    
    init(field: LargeTextBoxField) {
        self.id = field.id
        self.name = field.name
        self.text = field.text
    }
}

final class CPTRoundNumberFieldElement {
    let id: String
    let name: String
    var number: Int?
    
    init(field: RoundNumberField) {
        self.id = field.id
        self.name = field.name
        self.number = field.number
    }
}

final class CPTDecimalNumberFieldElement {
    let id: String
    let name: String
    var number: Double?
    
    init(field: DecimalNumberField) {
        self.id = field.id
        self.name = field.name
        self.number = field.number
    }
}

final class CPTCheckboxFieldElement {
    let id: String
    let name: String
    var value: Bool?
    
    init(field: CheckboxField) {
        self.id = field.id
        self.name = field.name
        self.value = field.value
    }
}

final class CPTDateFieldElement {
    let id: String
    let name: String
    var date: Date?
    
    init(field: DateField) {
        self.id = field.id
        self.name = field.name
        self.date = field.date
    }
}

final class CPTPhoneNumberFieldElement {
    let id: String
    let name: String
    var phoneNumber: String?
    
    init(field: PhoneNumberField) {
        self.id = field.id
        self.name = field.name
        self.phoneNumber = field.phoneNumber
    }
}

final class CPTWebLinkFieldElement {
    let id: String
    let name: String
    var link: String?
    
    init(field: WebLinkField) {
        self.id = field.id
        self.name = field.name
        self.link = field.link
    }
}

final class CPTEmailFieldElement {
    let id: String
    let name: String
    var email: String?
    
    init(field: EmailField) {
        self.id = field.id
        self.name = field.name
        self.email = field.email
    }
}
