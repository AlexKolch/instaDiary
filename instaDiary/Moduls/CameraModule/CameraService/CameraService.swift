//
//  CameraService.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 21.03.2024.
//

import AVFoundation

protocol CameraServiceProtocol: AnyObject {
    var captureSession: AVCaptureSession { get set } //сессия работы камеры
    var output: AVCapturePhotoOutput { get set } //то что видим в камере
    ///настройка сессии камеры
    func setupCaptureSession()
    func stopSession()
    func switchCamera()
}

class CameraService: CameraServiceProtocol {
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    var output: AVCapturePhotoOutput = AVCapturePhotoOutput()
    
    private var captureDevice: AVCaptureDevice? //наш девайс, сейчас установленная камера
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    
    private var backInput: AVCaptureInput!
    private var frontInput: AVCaptureInput!
    private var isBackCamera = true
    
    private let cameraQueue = DispatchQueue(label: "cameraQueue") //своя очередь
    
    func setupCaptureSession() {
        cameraQueue.async { [weak self] in
            self?.captureSession.beginConfiguration()
            //можем ли установить в качестве пресета фото
            if let isSetPreset = self?.captureSession.canSetSessionPreset(.photo), isSetPreset {
                self?.captureSession.sessionPreset = .photo
            }
            self?.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = false //расширеный цветовой диапазон, необязательно уст
            self?.setInputs()
            self?.setOutputs()
            
            self?.captureSession.commitConfiguration()
            self?.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        captureSession.stopRunning()
        captureSession.removeInput(backInput) //обязательно чистим инпуты
        captureSession.removeInput(frontInput)
        isBackCamera = true
    }
    
    func switchCamera() {
        captureSession.beginConfiguration()
        if isBackCamera { //вкл передняя камера
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            captureDevice = frontCamera
            isBackCamera = false
        } else { //вкл задняя камера
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            captureDevice = backCamera
            isBackCamera = true
        }
    }
    
    private func setInputs() {
        backCamera = currentDevice()
        frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        //создали и настроили камеры
        guard let backCamera, let frontCamera else { return }
        
        do {
            backInput = try AVCaptureDeviceInput(device: backCamera) //пробуем установить в качестве ввода камеры
            guard captureSession.canAddInput(backInput) else { return }
            
            frontInput = try AVCaptureDeviceInput(device: frontCamera)
            guard captureSession.canAddInput(frontInput) else { return }
            //Если удалось установить обе камеры в качестве ввода (input)
            //Чтобы все работало необходимо добавить инпуты в сессию
            captureSession.addInput(backInput)
            captureDevice = backCamera //сейчас установленная камера
        } catch {
            fatalError("not connect camera")
        }
    }
    ///устанавливаем в качестве вывода
    private func setOutputs() {
        guard captureSession.canAddOutput(output) else {return}
        
        output.maxPhotoQualityPrioritization = .balanced
        captureSession.addOutput(output)
    }
    
    ///настройка задней камеры
    private func currentDevice() -> AVCaptureDevice? {
        let sessionDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTripleCamera,
                                                                           .builtInDualCamera,
                                                                           .builtInWideAngleCamera,
                                                                           .builtInDualWideCamera],
                                                             mediaType: .video, position: .back)
        guard let device = sessionDevice.devices.first else { return nil }
        return device
    }
}
