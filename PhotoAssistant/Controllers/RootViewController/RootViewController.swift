//
//  ViewController.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 19.02.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit
import Photos

final class RootController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let cameraController = CameraController()
    let filtersCollectionViewContoller = FiltersCollectionViewController()
    
    // MARK: - Proprties' overrides
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var switchCamerasButton: UIButton!
    @IBOutlet weak var switchFlashlightButton: UIButton!
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var chooseFilterButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    // MARK: - Actions
    @IBOutlet weak var takenImageButton: UIButton!
    @IBOutlet var filtersCollectionView: FiltersCollectionVIew!
    
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        } catch {
            // TODO: - Implement error handling
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front): switchCamerasButton.setImage(#imageLiteral(resourceName: "Digitalcam"), for: .normal)
        case .some(.rear): switchCamerasButton.setImage(#imageLiteral(resourceName: "Digitalcamback"), for: .normal)
        case .none: return
        }
    }
    
    // MARK: -
    
    @IBAction func switchFlashlight(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            switchFlashlightButton.setImage(#imageLiteral(resourceName: "Noflash"), for: .normal)
        } else {
            cameraController.flashMode = .on
            switchFlashlightButton.setImage(#imageLiteral(resourceName: "Flashcircled"), for: .normal)
        }
    }
    
    // MARK: -
    
    @IBAction func chooseFilter(_ sender: UIButton) {
        showAndHideFilters()
    }
    
    // MARK: -
    
    @IBAction func takePhoto(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            DispatchQueue.main.async {
                self.takenImageButton.setImage(image, for: .normal)
            }
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
    
    // MARK: -
    
    @IBAction func viewTakenImage(_ sender: UIButton) {
    }
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Life cycle
extension RootController {
    override func viewDidLoad() {
        
        func configureCameraController() {
            cameraController.prepare { (error) in
                if let error = error {
                    // TODO: Implement error hadnling
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        super.viewDidLoad()
        configureCameraController()
        updateOrientation()
        setUI()
        filtersCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        filtersCollectionView.dataSource = filtersCollectionViewContoller
        filtersCollectionView.delegate = filtersCollectionViewContoller
        filtersCollectionView.reloadData()
    }
}

// MARK: - Methods
extension RootController {
    @objc
    fileprivate func updateOrientation() {
        let deviceOrientation = UIDevice.current.orientation
        let angle: CGFloat
        
        UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
        
        switch deviceOrientation {
        case .portraitUpsideDown: angle = .pi
        case .landscapeLeft: angle = .pi / 2
        case .landscapeRight: angle = -.pi / 2
        default: angle = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.switchCamerasButton.transform = CGAffineTransform(rotationAngle: angle)
            self.switchFlashlightButton.transform = CGAffineTransform(rotationAngle: angle)
            self.chooseFilterButton.transform = CGAffineTransform(rotationAngle: angle)
            self.takePhotoButton.transform = CGAffineTransform(rotationAngle: angle)
            self.takenImageButton.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    fileprivate func setUI() {
        takenImageButton.layer.cornerRadius = takenImageButton.bounds.height / 2
    }
    
    private func showAndHideFilters() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            if let weakSelf = self {
                weakSelf.filtersCollectionView.isHidden = !weakSelf.filtersCollectionView.isHidden
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showAndHideFilters()
    }
}
