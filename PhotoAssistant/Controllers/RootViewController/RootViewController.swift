//
//  ViewController.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 19.02.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

final class RootController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let cameraController = CameraController()
    override var prefersStatusBarHidden: Bool { return true }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var swicthCamerasButton: UIButton!
    @IBOutlet weak var switchFlashlightButton: UIButton!
    @IBOutlet weak var capturePreviewView: UIView!
    @IBOutlet weak var chooseFilterButton: UIButton!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    // MARK: - Actions
    @IBOutlet weak var takenImageButton: UIButton!
    
    @IBAction func switchCameras(_ sender: UIButton) {
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
        //TODO: Implement choosing filters
    }
    
    // MARK: -
    
    @IBAction func takePhoto(_ sender: UIButton) {
        //TODO: Implement taking a photo
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
            self.swicthCamerasButton.transform = CGAffineTransform(rotationAngle: angle)
            self.switchFlashlightButton.transform = CGAffineTransform(rotationAngle: angle)
            self.chooseFilterButton.transform = CGAffineTransform(rotationAngle: angle)
            self.takePhotoButton.transform = CGAffineTransform(rotationAngle: angle)
            self.takenImageButton.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}
