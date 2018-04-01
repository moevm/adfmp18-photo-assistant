//
//  CameraPresenter.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

protocol CameraPresentationLogic
{
    func presentConfigureCamera(response: Camera.Configure.Response)
    func presentShowPreview(response: Camera.ShowPreview.Response)
}

final class CameraPresenter: CameraPresentationLogic
{
    weak var viewController: CameraDisplayLogic?
    
    // MARK: - Present Configure Camera
    func presentConfigureCamera(response: Camera.Configure.Response) {
        let viewModel: Camera.Configure.ViewModel
        let error = response.error
        if let error = error {
            viewModel = Camera.Configure.ViewModel(errorMessage: error.localizedDescription)
        } else {
            viewModel = Camera.Configure.ViewModel(errorMessage: nil)
        }
        viewController?.displayConfigureCamera(viewModel: viewModel)
    }
    
    // MARK: - Present Show Preview
    
    func presentShowPreview(response: Camera.ShowPreview.Response) {
        let viewModel: Camera.ShowPreview.ViewModel
        if let error = response.error {
            viewModel = Camera.ShowPreview.ViewModel(errorMessage: error.localizedDescription, previewLayer: response.previewLayer)
        } else {
            viewModel = Camera.ShowPreview.ViewModel(errorMessage: nil, previewLayer: response.previewLayer)
        }
        viewController?.displayShowPreview(viewModel: viewModel)
    }
}
