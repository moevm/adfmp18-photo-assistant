//
//  CameraModels.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit
import AVFoundation

enum Camera
{
    // MARK: Use cases
    
    enum Configure
    {
        struct Request {}
        
        struct Response
        {
            let error: Error?
        }
        struct ViewModel
        {
            let errorMessage: String?
        }
    }
    
    enum ShowPreview {
        struct Request {
            let size: CGRect
        }
        
        struct Response {
            let error: Error?
            let previewLayer: AVCaptureVideoPreviewLayer?
        }
        
        struct ViewModel {
            let errorMessage: String?
            let previewLayer: AVCaptureVideoPreviewLayer?
        }
    }
    
    enum UpdateOrientation {
        struct Request {}
        struct Response {
            let angle: CGFloat
        }
        struct ViewModel {
            let angle: CGFloat
        }
    }
    
}

enum CameraError: LocalizedError {
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    
    var errorDescription: String? {
        switch self {
        case .captureSessionIsMissing: return "Capture Session Is Missing"
        case .inputsAreInvalid: return "Inputs Are Invalid"
        case .invalidOperation: return "Invalid Operation"
        case .noCamerasAvailable: return "No cameras available"
        }
    }
}

enum CameraPosition {
    case front
    case rear
}
