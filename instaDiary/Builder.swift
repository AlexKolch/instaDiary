//
//  Builder.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 03.03.2024.
//

import UIKit

protocol BuilderProtocol {
    static func getPasscodeController(state: PasscodeState, sceneDelegate: SceneDelegateProtocol?, wasSetting: Bool) -> UIViewController
    static func createTabBarController() -> UIViewController
    static func createMainScreenController() -> UIViewController
    static func createFavoriteScreenController() -> UIViewController
    static func createCameraScreenController() -> UIViewController
}

class Builder: BuilderProtocol {
    
    static func getPasscodeController(state: PasscodeState, sceneDelegate: SceneDelegateProtocol?, wasSetting: Bool) -> UIViewController {
        let passcodeView = PasscodeView()
        let keychainManager = KeychainManager()
        let presenter = PasscodePresenter(view: passcodeView, state: state, keychainManager: keychainManager, delegate: sceneDelegate, wasSetting: wasSetting)
        passcodeView.passcodePresenter = presenter
        return passcodeView
    }
    
    static func createTabBarController() -> UIViewController {
        let tabBarView = TabBarView()
        let presenter = TabBarPresenter(view: tabBarView)
        
        tabBarView.presenter = presenter
        return tabBarView
    }
    
    static func createMainScreenController() -> UIViewController {
        let mainView = MainScreenView()
        let presenter = MainScreenPresenter(view: mainView)
        mainView.presenter = presenter
        return CustomNavigationController(rootViewController: mainView)
    }
    
    static func createFavoriteScreenController() -> UIViewController {
        let favoriteView = FavoriteView()
        let presenter = FavoritePresenter(view: favoriteView)
        
        favoriteView.presenter = presenter
        
        return UINavigationController(rootViewController: favoriteView)
    }
    
    static func createCameraScreenController() -> UIViewController {
        let cameraView = CameraView()
        let cameraService = CameraService()
        
        let presenter = CameraViewPresenter(view: cameraView, cameraService: cameraService)
        
        cameraView.presenter = presenter
        return UINavigationController(rootViewController: cameraView) 
    }
    
    static func createDetailsController(item: PostItem) -> UIViewController {
        let detailsView = DetailsView()
        let presenter = DetailsPresenter(view: detailsView, item: item)
        
        detailsView.presenter = presenter
        return detailsView
    }
    
    ///for child VC
    static func createPhotoViewController(image: UIImage?) -> UIViewController {
        let photoView = PhotoView()
        let presenter = PhotoViewPresenter(view: photoView, image: image)
        photoView.presenter = presenter
        return photoView
    }
    
    static func createAddPostViewController(photos: [UIImage]) -> UIViewController {
        let addPostView = AddPostView()
        let presenter = AddPostPresenter(view: addPostView, photos: photos)
        
        addPostView.presenter = presenter
        return addPostView
    }
    
    static func createSettingsViewController() -> UIViewController {
        let settingsView = SettingsView()
        let presenter = SettingsPresenter(view: settingsView)
        
        settingsView.presenter = presenter
        return UINavigationController(rootViewController: settingsView)
    }
}
