//
//  CameraViewPresenter.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 20.03.2024.
//

import UIKit

protocol CameraViewPresenterProtocol: AnyObject {
    init(view: CameraViewProtocol, cameraService: CameraServiceProtocol)
    var photos: [UIImage] {get set}
    var cameraService: CameraServiceProtocol {get set}
    var closeViewAction: UIAction? {get set}
    var switchCamera: UIAction? {get set}
    func deleteImage(for index: Int)
}

class CameraViewPresenter: CameraViewPresenterProtocol {
    
    private weak var view: CameraViewProtocol?
    
    var cameraService: CameraServiceProtocol
    var photos: [UIImage] = []
    
    lazy var closeViewAction: UIAction? = UIAction { [weak self] _ in
        NotificationCenter.default.post(name: .goToMain, object: nil)
        self?.cameraService.stopSession()
        self?.photos.removeAll() //очищаюся недавние фотки в коллекции на экране CameraView
    }
    
    lazy var switchCamera: UIAction? = UIAction { [weak self] _ in
        self?.cameraService.switchCamera()
    }
    
    required init(view: CameraViewProtocol, cameraService: CameraServiceProtocol) {
        self.view = view
        self.cameraService = cameraService
    }
    
    func deleteImage(for index: Int) {
        photos.remove(at: index)
    }
    
}
