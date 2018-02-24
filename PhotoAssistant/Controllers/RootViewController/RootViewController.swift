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
    
    // MARK: - Outlets
    
    @IBOutlet weak var swicthCamerasButton: UIButton!
    @IBOutlet weak var switchFlashlightButton: UIButton!
    @IBOutlet weak var capturePreviewView: UIView!
    
    // MARK: - Actions
    
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
        
        super.viewDidLoad()
        configureCameraController()
    }
}
