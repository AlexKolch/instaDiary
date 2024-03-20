//
//  PhotoView.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 20.03.2024.
//

import UIKit

protocol PhotoViewProtocol: AnyObject {
    var closeBtnAction: UIAction {get set}
}

class PhotoView: UIViewController, PhotoViewProtocol {
    
    var presenter: PhotoViewPresenterProtocol!
    var completion: (()->())?
    
    lazy var closeBtnAction = UIAction { [weak self] _ in
        self?.completion?()
    }
    
    private lazy var closeButton: UIButton = {
        $0.setBackgroundImage(.closeIcon, for: .normal)
        return $0
    }(UIButton(frame: CGRect(x: view.bounds.width - 60, y: 60, width: 25, height: 25), primaryAction: closeBtnAction))
    
    private lazy var scrollView: UIScrollView = {
        $0.maximumZoomScale = 5
        $0.backgroundColor = .black
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.addGestureRecognizer(tapGesture)
        $0.addSubview(image)
        return $0
    }(UIScrollView(frame: view.bounds))
    
    lazy var tapGesture: UITapGestureRecognizer = {
        $0.numberOfTapsRequired = 2
        $0.addTarget(self, action: #selector(zoomImage))
        return $0
    }(UITapGestureRecognizer())
    
    private lazy var image: UIImageView = {
        $0.image = presenter.image
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        setImageSize()
    }
    ///расчет пропорции изображения
    private func setImageSize() {
        let imageSize = image.image?.size //получили реальный размер картинки
        let imageHeight = imageSize?.height ?? 0 //реальная высота картинки
        let imageWidth = imageSize?.width ?? 0
        
        let ratio = imageHeight/imageWidth //соотношение высоты к ширине
        
        ///картинка будет сохранять пропорции в зависимости от ширины экрана (на планшете высота растянется относительно ширины экрана)
        image.frame.size = CGSize(width: view.frame.width, height: view.frame.width * ratio)
        image.center = view.center
    }
    
    @objc func zoomImage() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else {return}
            if self.scrollView.zoomScale > 1 {
                self.scrollView.zoomScale = 1
            } else {
                self.scrollView.zoomScale = 2
            }
        }
    }

    deinit {
        print(#function + " photoView")
    }
}

extension PhotoView: UIScrollViewDelegate {
    ///определяет какую вью скроллить
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    ///срабатывает после скрола
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //Выравниваем по центру при скроле увеличения изображения
        if scrollView.contentSize.height > view.frame.height {
            image.center.y = scrollView.contentSize.height / 2 //ВАЖНО! чтобы не было бага с уходом картинки выше фрейма view
        } else {
            image.center.y = view.center.y
        }
    }
}
