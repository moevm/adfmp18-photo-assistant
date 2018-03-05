//
//  CameraController.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 20.02.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraController {
    // capture session
    fileprivate var captureSession: AVCaptureSession?
    
    // cameras
    fileprivate var frontCamera: AVCaptureDevice?
    fileprivate var rearCamera: AVCaptureDevice?
    
    // device inputs
    fileprivate var currentCameraPosition: CameraPosition?
    fileprivate var frontCameraInput: AVCaptureDeviceInput?
    fileprivate var rearCameraInput: AVCaptureDeviceInput?
    
    // output
    fileprivate var photoOutput: AVCapturePhotoOutput?
    
    // preview
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.off
}

// MARK: - Methods

extension CameraController {
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = session.devices.flatMap {$0}
            guard !cameras.isEmpty else {
                throw CameraControllerError.noCamerasAvailable
            }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
                }
                
                self.currentCameraPosition = .rear
                
            } else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(frontCameraInput!) {
                    captureSession.addInput(frontCameraInput!)
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
                
                self.currentCameraPosition = .front
                
            } else {
                throw CameraControllerError.noCamerasAvailable
            }
            
            
        }
        
        // TODO: Configure a photo output object to pocess captured images
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])])
            
            if captureSession.canAddOutput(self.photoOutput!) {
                captureSession.addOutput(self.photoOutput!)
            }
            
            captureSession.startRunning()
            
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }

    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.bounds
    }
}

extension CameraController {
    // TODO: Implement conformation to LocalizedError
    enum CameraControllerError: Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    enum CameraPosition {
        case front
        case rear
    }
}
