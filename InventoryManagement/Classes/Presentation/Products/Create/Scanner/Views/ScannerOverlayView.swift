//
//  ScannerOverlayView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import UIKit

final class ScannerOverlayView: UIView {
    lazy var cameraPreview = makeCameraPreview()
    
    private var maskLayer: CAShapeLayer?
    private var borderLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawOverlay()
    }
}

// MARK: Public
extension ScannerOverlayView {
    var scanRect: CGRect {
        calculateCenteredScanRect()
    }
}

// MARK: Private
private extension ScannerOverlayView {
    func initialize() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
    }
    
    func drawOverlay() {
        maskLayer?.removeFromSuperlayer()
        borderLayer?.removeFromSuperlayer()

        let fullPath = UIBezierPath(rect: bounds)
        let scanRect = calculateCenteredScanRect()
        let cutoutPath = UIBezierPath(roundedRect: scanRect, cornerRadius: 32.scale)

        fullPath.append(cutoutPath)
        fullPath.usesEvenOddFillRule = true

        let newMaskLayer = CAShapeLayer()
        newMaskLayer.path = fullPath.cgPath
        newMaskLayer.fillRule = .evenOdd
        newMaskLayer.fillColor = Appearance.mono200.withAlphaComponent(0.6).cgColor
        layer.addSublayer(newMaskLayer)
        maskLayer = newMaskLayer

        let newBorderLayer = CAShapeLayer()
        newBorderLayer.path = UIBezierPath(roundedRect: scanRect, cornerRadius: 32.scale).cgPath
        newBorderLayer.strokeColor = Appearance.main200.cgColor
        newBorderLayer.lineWidth = 4.scale
        newBorderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(newBorderLayer)
        borderLayer = newBorderLayer
    }

    func calculateCenteredScanRect() -> CGRect {
        let scanAreaSize = CGSize(width: 282.scale, height: 172.scale)
        let originX = (bounds.width - scanAreaSize.width) / 2
        let originY = (bounds.height - scanAreaSize.height) / 2
        return CGRect(origin: CGPoint(x: originX, y: originY), size: scanAreaSize)
    }
}

// MARK: Make constraints
private extension ScannerOverlayView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            cameraPreview.leadingAnchor.constraint(equalTo: leadingAnchor),
            cameraPreview.trailingAnchor.constraint(equalTo: trailingAnchor),
            cameraPreview.topAnchor.constraint(equalTo: topAnchor),
            cameraPreview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ScannerOverlayView {
    func makeCameraPreview() -> ScannerCameraPreviewView {
        let view = ScannerCameraPreviewView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 32.scale
        view.layer.masksToBounds = true
        view.previewLayer.videoGravity = .resizeAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
