//
//  CameraViewController.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

protocol CameraDisplayLogic: class
{
    func displayConfigureCamera(viewModel: Camera.Configure.ViewModel)
    func displayShowPreview(viewModel: Camera.ShowPreview.ViewModel)
    func displayUpdateOrientation(viewModel: Camera.UpdateOrientation.ViewModel)
    func displayCaptureImage(viewModel: Camera.CaptureImage.ViewModel)
}

final class CameraViewController: UIViewController, CameraDisplayLogic
{
    // MARK: - Properties
    
    var interactor: CameraBusinessLogic?
    var router: (NSObjectProtocol & CameraRoutingLogic & CameraDataPassing)?
    
    // MARK: -
    
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = CameraInteractor()
        let presenter = CameraPresenter()
        let router = CameraRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureCamera()
        updateOrientaion()
    }
    
    // MARK: - Configure Camera
    
    private func configureCamera() {
        let request = Camera.Configure.Request()
        interactor?.configureCamera(request: request)
    }
    
    // MARK: -
    
    func displayConfigureCamera(viewModel: Camera.Configure.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            showAlert(withTitle: "Error", and: errorMessage)
        } else {
            showPreview()
        }
    }
    
    // MARK: - Show Preview
    
    @IBOutlet var previewView: UIView!
    
    private func showPreview() {
        let request = Camera.ShowPreview.Request(size: previewView.bounds)
        interactor?.showPreview(request: request)
    }
    
    // MARK: -
    
    func displayShowPreview(viewModel: Camera.ShowPreview.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            showAlert(withTitle: "Error", and: errorMessage)
        } else if let layer = viewModel.previewLayer{
            previewView.layer.insertSublayer(layer, at: 0)
        }
    }
    
    // MARK: - UpdateOrienation
    
    @IBOutlet var switchCamerasButton: UIButton!
    @IBOutlet var toggleFlashlightButton: UIButton!
    @IBOutlet var chooseFilterButton: UIButton!
    @IBOutlet var takePhotoButton: UIButton!
    @IBOutlet var viewTakenPhotoButton: UIButton! {
        didSet {
            viewTakenPhotoButton.layer.cornerRadius = viewTakenPhotoButton.bounds.height / 2
        }
    }
    
    
    private func updateOrientaion() {
        let request = Camera.UpdateOrientation.Request()
        interactor?.updateOrientation(request: request)
    }
    
    // MARK: -
    
    func displayUpdateOrientation(viewModel: Camera.UpdateOrientation.ViewModel) {
        let angle = viewModel.angle
        UIView.animate(withDuration: 0.3) {
            self.switchCamerasButton.transform = CGAffineTransform(rotationAngle: angle)
            self.toggleFlashlightButton.transform = CGAffineTransform(rotationAngle: angle)
            self.chooseFilterButton.transform = CGAffineTransform(rotationAngle: angle)
            self.takePhotoButton.transform = CGAffineTransform(rotationAngle: angle)
            self.viewTakenPhotoButton.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    // MARK: - Capture Image
    
    @IBAction func captureImage(_ sender: UIButton) {
        let request = Camera.CaptureImage.Request()
        interactor?.captureImage(request: request)
    }
    
    
    func displayCaptureImage(viewModel: Camera.CaptureImage.ViewModel) {
        if let image = viewModel.image {
            viewTakenPhotoButton.setImage(image, for: .normal)
        } else if let errorMessage = viewModel.errorMessage {
            showAlert(withTitle: "Error", and: errorMessage)
        }
    }
}
