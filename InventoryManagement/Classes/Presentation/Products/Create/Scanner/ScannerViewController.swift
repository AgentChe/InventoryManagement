//
//  ScannerViewController.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 10.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ScannerViewController: UIViewController {
    private lazy var mainView = ScannerView()
    
    private lazy var viewModel = ScannerViewModel()
    
    private lazy var closeButton = TapAreaButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didDetectedBarcodeTrigger = PublishRelay<Barcode?>()
    
    private lazy var scanner = ScannerAVCapture { [weak self] code in
        self?.didDetectedBarcodeTrigger.accept(code)
    }
    
    private var choosePhotoFromGallery: ChoosePhotoFromGallery?
    
    private var isRectOfInterestSet = false
    
    private let result: (Barcode) -> Void
    
    private init(result: @escaping (Barcode) -> Void) {
        self.result = result
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: ScannerViewModel.Input(
            didTapClose: closeButton.rx.tap.asSignal(),
            didTapFlash: mainView.controlsView.flashButton.rx.tap.asSignal(),
            didTapWallpapers: mainView.controlsView.wallpapersButton.rx.tap.asSignal(),
            didDetectedBarcode: didDetectedBarcodeTrigger.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        addCloseButton()
        configureScanner()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scanner.startRunning()
        applyNavSettings(isDefault: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        scanner.stopRunning()
        applyNavSettings(isDefault: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard !isRectOfInterestSet else { return }

        let cameraPreview = mainView.overlayView.cameraPreview
        let previewLayer = cameraPreview.previewLayer
        
        cameraPreview.layoutIfNeeded()
        previewLayer.frame = cameraPreview.bounds

        let scanRect = mainView.overlayView.scanRect

        scanner.setRectOfInterest(from: scanRect, in: previewLayer)

        isRectOfInterestSet = true
    }
}

// MARK: Public
extension ScannerViewController {
    static func make(result: @escaping (Barcode) -> Void) -> ScannerViewController {
        let vc = ScannerViewController(result: result)
        vc.navigationItem.title = "Scanner.Title".localized
        return vc
    }
}

// MARK: Private
private extension ScannerViewController {
    func action(_ action: ScannerViewModel.Action) {
        switch action {
        case .close:
            navigationController?.dismiss(animated: true)
        case .toggleFlash:
            scanner.toggleFlash()
        case .detectBarcodeFromGallery:
            choosePhotoFromGallery = ChoosePhotoFromGallery { image in
                DetectBarcodeImage().detectBarcode(from: image) { code in
                    DispatchQueue.main.async { [weak self] in 
                        self?.didDetectedBarcodeTrigger.accept(code)
                    }
                }
            }
            choosePhotoFromGallery?.choose(from: self)
        case .notifyErrorDetectBarcode:
            let alert = UIAlertController(title: nil, message: "Scanner.ErrorDetectBarcode".localized, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK".localized, style: .cancel)
            alert.addAction(okAction)
            
            present(alert, animated: true)
        case .result(let code):
            result(code)
        }
    }
    
    func configureScanner() {
        let cameraPreview = mainView.overlayView.cameraPreview
        let previewLayer = cameraPreview.previewLayer
        
        previewLayer.session = scanner.captureSession
    }
    
    func addCloseButton() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Close.White"), for: .normal)
        
        let item = UIBarButtonItem(customView: closeButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.leftBarButtonItem = item
    }
    
    func applyNavSettings(isDefault: Bool) {
        let whiteSettings = NavigationControllerSettings(
            backgroundImage: UIImage(),
            shadowImage: UIImage(),
            isTranslucent: true,
            tintColor: Appearance.mono100,
            titleTextAttrributes: TextAttributes()
                .textColor(Appearance.mono100)
                .font(Fonts.SFPro.bold(size: 17.scale))
                .textAlignment(.center)
                .dictionary
        )
        
        let settings = isDefault ? NavigationControllerSettings.default() : whiteSettings
        
        guard let nc = navigationController as? NavigationController else { return }
        
        nc.apply(settings: settings)
    }
}
