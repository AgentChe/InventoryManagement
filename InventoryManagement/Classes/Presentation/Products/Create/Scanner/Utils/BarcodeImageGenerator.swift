//
//  BarcodeImageGenerator.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import UIKit
import CoreImage

final class BarcodeImageGenerator {
    private let context = CIContext()

    func generate(from barcode: Barcode, scale: CGFloat = 5) -> UIImage? {
        guard let filter = makeFilter(for: barcode) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        let transformed = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        return UIImage(ciImage: transformed)
    }

    private func makeFilter(for barcode: Barcode) -> CIFilter? {
        guard let data = barcode.value.data(using: .ascii) else { return nil }

        switch barcode.type {
        case .qr:
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            return filter

        case .code128, .ean13, .ean8, .upce:
            let filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue(0, forKey: "inputQuietSpace")
            return filter

        case .aztec:
            let filter = CIFilter(name: "CIAztecCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            return filter

        case .pdf417:
            let filter = CIFilter(name: "CIPDF417BarcodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            return filter

        case .dataMatrix:
            let filter = CIFilter(name: "CIDataMatrixCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            return filter

        case .unknown:
            return nil
        }
    }
}
