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
    
    // MARK: - Outlets
    
    @IBOutlet weak var swicthCamerasButton: UIButton!
    @IBOutlet weak var switchFlashlightButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func switchCameras(_ sender: UIButton) {
    }
    
    // MARK: -
    
    @IBAction func switchFlashlight(_ sender: UIButton) {
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

