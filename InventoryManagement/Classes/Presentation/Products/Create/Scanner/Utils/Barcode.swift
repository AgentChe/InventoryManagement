//
//  Barcode.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import Vision
import AVFoundation

struct Barcode {
    let value: String
    let type: BarcodeType

    init(value: String, type: BarcodeType) {
        self.value = value
        self.type = type
    }
}

enum BarcodeType: String {
    case qr = "QR"
    case ean8 = "EAN-8"
    case ean13 = "EAN-13"
    case code128 = "Code 128"
    case upce = "UPC-E"
    case aztec = "Aztec"
    case pdf417 = "PDF417"
    case dataMatrix = "Data Matrix"
    case unknown = "Unknown"

    init(from symbology: VNBarcodeSymbology) {
        switch symbology {
        case .qr: self = .qr
        case .ean8: self = .ean8
        case .ean13: self = .ean13
        case .code128: self = .code128
        case .upce: self = .upce
        case .aztec: self = .aztec
        case .pdf417: self = .pdf417
        case .dataMatrix: self = .dataMatrix
        default: self = .unknown
        }
    }

    init(from avType: AVMetadataObject.ObjectType) {
        switch avType {
        case .qr: self = .qr
        case .ean8: self = .ean8
        case .ean13: self = .ean13
        case .code128: self = .code128
        case .upce: self = .upce
        case .aztec: self = .aztec
        case .pdf417: self = .pdf417
        case .dataMatrix: self = .dataMatrix
        default: self = .unknown
        }
    }
}
