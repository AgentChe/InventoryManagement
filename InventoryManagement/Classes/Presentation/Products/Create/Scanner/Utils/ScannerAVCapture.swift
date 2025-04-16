//
//  ScannerAVCapture.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import AVFoundation
import UIKit

final class ScannerAVCapture: NSObject {
    lazy var captureSession = AVCaptureSession()
    
    private lazy var metadataOutput = AVCaptureMetadataOutput()
    
    private let result: (Barcode) -> Void
    
    private var isRunning = false
    private var isHandlingResult = false
    
    init(result: @escaping (Barcode) -> Void) {
        self.result = result
        
        super.init()
        
        configureScanner()
    }
}

// MARK: Public
extension ScannerAVCapture {
    func startRunning() {
        guard !isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
            self?.isHandlingResult = false
            self?.isRunning = true
        }
    }

    func stopRunning() {
        guard isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
            self?.isRunning = false
        }
    }
    
    var flashEnable: Bool {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return false }
        return device.torchMode == .on
    }

    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = device.torchMode == .on ? .off : .on
        device.unlockForConfiguration()
    }
    
    func setRectOfInterest(from scanRect: CGRect, in previewLayer: AVCaptureVideoPreviewLayer) {
        let convertedRect = previewLayer.metadataOutputRectConverted(fromLayerRect: scanRect)
        metadataOutput.rectOfInterest = convertedRect
    }
    
    func makePreviewLayer() -> AVCaptureVideoPreviewLayer {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        return layer
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension ScannerAVCapture: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !isHandlingResult else { return }
        
        guard
            let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = metadata.stringValue
        else { return }

        isHandlingResult = true
        stopRunning()
        
        let type = BarcodeType(from: metadata.type)
        let barcode = Barcode(value: code, type: type)
        result(barcode)
    }
}

// MARK: Private
private extension ScannerAVCapture {
    func configureScanner() {
        guard
            let videoDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoInput)
        else { return }

        captureSession.beginConfiguration()
        captureSession.addInput(videoInput)
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .qr, .code128, .upce, .aztec, .pdf417, .dataMatrix]
        }

        captureSession.commitConfiguration()
    }
}
