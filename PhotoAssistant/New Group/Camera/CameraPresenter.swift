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
  func presentSomething(response: Camera.Something.Response)
}

class CameraPresenter: CameraPresentationLogic
{
  weak var viewController: CameraDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Camera.Something.Response)
  {
    let viewModel = Camera.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
