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
  func doSomething(request: Camera.Something.Request)
}

protocol CameraDataStore
{
  //var name: String { get set }
}

class CameraInteractor: CameraBusinessLogic, CameraDataStore
{
  var presenter: CameraPresentationLogic?
  var worker: CameraWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Camera.Something.Request)
  {
    worker = CameraWorker()
    worker?.doSomeWork()
    
    let response = Camera.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
