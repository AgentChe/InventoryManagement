//
//  DetectBarcodeImage.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import Vision
import UIKit

final class DetectBarcodeImage {
    func detectBarcode(from image: UIImage, completion: @escaping (Barcode?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let request = VNDetectBarcodesRequest { request, error in
            if let results = request.results as? [VNBarcodeObservation], let first = results.first, let payload = first.payloadStringValue {
                let type = BarcodeType(from: first.symbology)
                let barcode = Barcode(value: payload, type: type)
                completion(barcode)
            } else {
                completion(nil)
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(nil)
            }
        }
    }
}
