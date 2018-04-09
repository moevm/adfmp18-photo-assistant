//
//  PhotoInteractor.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 03.04.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

protocol PhotoBusinessLogic
{
    func showPhoto(request: Photo.ShowPhoto.Request)
}

protocol PhotoDataStore
{
    var imageData: Data? { get set }
}

class PhotoInteractor: PhotoBusinessLogic, PhotoDataStore
{
    var presenter: PhotoPresentationLogic?
    var worker: PhotoWorker?
    var imageData: Data?
    
    //var name: String = ""
    
    // MARK: Do something
    func showPhoto(request: Photo.ShowPhoto.Request) {
        if let imageData = imageData {
            let response = Photo.ShowPhoto.Response(imageData: imageData)
            presenter?.presentShowPhoto(response: response)
        }
    }
}
