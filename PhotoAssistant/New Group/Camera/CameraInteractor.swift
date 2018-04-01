//
//  CameraInteractor.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

protocol CameraBusinessLogic
{
    func configureCamera(request: Camera.Configure.Request)
    func showPreview(request: Camera.ShowPreview.Request)
    func updateOrientation(request: Camera.UpdateOrientation.Request)
    func captureImage(request: Camera.CaptureImage.Request)
    func switchCameras(request: Camera.SwitchCameras.Request)
    func toggleFlashlight(request: Camera.ToggleFlashLight.Request)
}

protocol CameraDataStore
{
    //var name: String { get set }
}

final class CameraInteractor: CameraBusinessLogic, CameraDataStore
{
    var presenter: CameraPresentationLogic?
    
    // MARK: - Properties
    private let cameraConfigurator = CameraConfigurator()
    private var updateOrientationWorker = UpdateOrientationWorker()
    private lazy var captureImageWorker = CaptureImageWorker(configuration: cameraConfigurator)
    
    // MARK: - Object Life Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configure Camera
    
    func configureCamera(request: Camera.Configure.Request) {
        cameraConfigurator.prepare(completionHandler: { (error) in
            var response: Camera.Configure.Response
            if let error = error {
                response = Camera.Configure.Response(error: error)
            } else {
                response = Camera.Configure.Response(error: nil)
            }
            self.presenter?.presentConfigureCamera(response: response)
        })
    }
    
    // MARK: - Show Preview
    
    func showPreview(request: Camera.ShowPreview.Request) {
        let showPreviewWorker = ShowPreviewWorker()
        let size = request.size
        let response: Camera.ShowPreview.Response
        do {
            let previewLayer = try showPreviewWorker.showPreview(ofSize: size, configurator: cameraConfigurator)
            response = Camera.ShowPreview.Response(error: nil, previewLayer: previewLayer)
        } catch let error {
            response = Camera.ShowPreview.Response(error: error, previewLayer: nil)
        }
        presenter?.presentShowPreview(response: response)
    }
    
    // MARK: - Update Orientation
    
    func updateOrientation(request: Camera.UpdateOrientation.Request) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(calculateAngle), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc private func calculateAngle() {
        let angle = updateOrientationWorker.angleToRotate
        let response = Camera.UpdateOrientation.Response(angle: angle)
        presenter?.presentUpdateOrientation(response: response)
    }
    
    // MARK: - Capture Image
    
    func captureImage(request: Camera.CaptureImage.Request) {
        captureImageWorker.captureImage { [weak self] (data, error) in
            let response: Camera.CaptureImage.Response
            if let data = data {
                response = Camera.CaptureImage.Response(imageData: data, error: nil)
            } else {
                response = Camera.CaptureImage.Response(imageData: nil, error: error!)
            }
            self?.presenter?.presentCaptureImage(response: response)
        }
    }
    
    // MARK: - Switch Cameras
    
    func switchCameras(request: Camera.SwitchCameras.Request) {
        let switchCamerasWorker = SwitchCamerasWorker(configuration: cameraConfigurator)
        let response: Camera.SwitchCameras.Response
        do {
            try switchCamerasWorker.switchCameras()
            response = Camera.SwitchCameras.Response(error: nil)
        } catch let error {
            response = Camera.SwitchCameras.Response(error: error)
        }
        presenter?.presentSwitchCameras(response: response)
    }
    
    // MARK: - Toggle Flashlight
    
    func toggleFlashlight(request: Camera.ToggleFlashLight.Request) {
        let toggleFlashlightWorker = ToggleFlashlightWorker(configuration: cameraConfigurator)
        let state = toggleFlashlightWorker.toggleFlashLight()
        let response = Camera.ToggleFlashLight.Response(state: state)
        presenter?.presentToggleFlashLight(response: response)
    }
}
