//
//  PhotoPresenter.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 03.04.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

protocol PhotoPresentationLogic
{
    func presentShowPhoto(response: Photo.ShowPhoto.Response)
}

class PhotoPresenter: PhotoPresentationLogic
{
  weak var viewController: PhotoDisplayLogic?
  
  // MARK: Do something
  
    func presentShowPhoto(response: Photo.ShowPhoto.Response) {
        if let image = UIImage(data: response.imageData) {
            print("image created")
            let viewModel = Photo.ShowPhoto.ViewModel(image: image)
            viewController?.displayShowPhoto(viewModel: viewModel)
        }
    }
}
