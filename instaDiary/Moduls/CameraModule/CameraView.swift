//
//  CameraView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 08.03.2024.
//

import UIKit
import AVFoundation

protocol CameraViewDelegate: AnyObject {
    func deleteImage(for index: Int)
}

protocol CameraViewProtocol: AnyObject {
}

class CameraView: UIViewController, CameraViewProtocol {
    
    var presenter: CameraViewPresenterProtocol!
//MARK: - UI config
    lazy var shotsCollectionView: UICollectionView = {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 60, height: 60)
        
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "shotCell")
        $0.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.dataSource = self
        return $0
    }(UICollectionView(frame: CGRect(x: 0, y: 60, width: view.frame.width - 110, height: 60), collectionViewLayout: UICollectionViewFlowLayout()))
    
    private lazy var closeBtn: UIButton = {
        $0.setBackgroundImage(.closeIcon, for: .normal)
        return $0
    }(UIButton(frame: CGRect(x: view.frame.width - 60, y: 60, width: 25, height: 25), primaryAction: presenter.closeViewAction))
    
    private lazy var shotBtn: UIButton = {
        $0.setBackgroundImage(.shotBtn, for: .normal)
        return $0
    }(UIButton(frame: CGRect(x: view.center.x - 30, y: view.frame.height - 110, width: 60, height: 60), primaryAction: shotAction))
    
    private lazy var shotAction = UIAction { [weak self] _ in
        print(#function)
        guard let self else {return}
        let photoSettings = AVCapturePhotoSettings() //настройки камеры
        photoSettings.flashMode = .auto
        self.presenter.cameraService.output.capturePhoto(with: photoSettings, delegate: self)
    }
    
    private lazy var switchBtn: UIButton = {
        $0.setBackgroundImage(.switchCamera, for: .normal)
        return $0
    }(UIButton(frame: CGRect(x: shotBtn.frame.origin.x - 60, y: shotBtn.frame.origin.y + 17.5, width: 25, height: 25), primaryAction: presenter.switchCameraAction))
    
    private lazy var nextBtn: UIButton = {
        $0.setTitle("Далее", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.opacity = 0.6
        $0.isEnabled = false
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 17.5
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.frame.size = CGSize(width: 100, height: 35)
        $0.frame.origin = CGPoint(x: shotBtn.frame.origin.x + 90, y: shotBtn.frame.origin.y + 12.5)
        return $0
    }(UIButton(primaryAction: nextBtnAction))
    
    lazy var nextBtnAction = UIAction { [weak self] _ in
        guard let self = self else {return}
        if let addPostVC = Builder.createAddPostViewController(photos: self.presenter.photos) as? AddPostView {
            addPostVC.delegate = self
            navigationController?.pushViewController(addPostVC, animated: true)
        }
    }
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        setPreviewLayer()
     
        view.addSubview(shotsCollectionView)
        view.addSubview(closeBtn)
        view.addSubview(shotBtn)
        view.addSubview(switchBtn)
        view.addSubview(nextBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.cameraService.setupCaptureSession()
        
        if presenter.photos.count == 0 {
            shotsCollectionView.reloadData()
        }
        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide" : true])
        navigationController?.navigationBar.isHidden = true
    }
//MARK: - private func
    ///Проверяет доступ к камере
    private func checkPermission() {
        let cameraStatusAuth = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraStatusAuth {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isAuth in
                if !isAuth {
                    abort()
                }
            }
        case .restricted, .denied:
            abort() //ничего не будет
        case .authorized:
            return
        default:
            fatalError()
        }
    }
    ///Настройка превью камеры
    private func setPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: presenter.cameraService.captureSession)
        
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
}
//MARK: - extension AVCapturePhotoCaptureDelegate
extension CameraView: AVCapturePhotoCaptureDelegate {
    ///Срабатывает когда нажали сделать снимок
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        guard let photoData = photo.fileDataRepresentation() else { return }
        if let image = UIImage(data: photoData) {
            presenter.photos.append(image)
            
            nextBtn.layer.opacity = 1.0
            nextBtn.isEnabled = true
            
            self.shotsCollectionView.reloadData()
        }
    } 
}
//MARK: - extension UICollectionViewDataSource
extension CameraView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shotCell", for: indexPath)
        let photo = presenter.photos[indexPath.item] //взяли фоку
        let imageView: UIImageView = .setImageView(image: photo)
        cell.addSubview(imageView)
        return cell
    }
    
}

//MARK: - Delegate
extension CameraView: CameraViewDelegate {
    func deleteImage(for index: Int) {
        presenter.deleteImage(for: index)
        
        if presenter.photos.count == 0 {
            nextBtn.layer.opacity = 0.6
            nextBtn.isEnabled = false
        }
        
        shotsCollectionView.reloadData()
    }
}

