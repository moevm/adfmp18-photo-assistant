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
}
