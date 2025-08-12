import UIKit
import Photos
final class UtilsPhotoGallery: NSObject {
    static let sharedInstance = UtilsPhotoGallery()
    var viewController: UIViewController?
    var imagePickerController = UIImagePickerController()
    override init() {
		UtilsLogger.log("PhotoGalleryUtils \(#function)")
    }
    func showOptionList (_ _viewController : UIViewController, _ _imagePickerController: UIImagePickerController) {
        imagePickerController = _imagePickerController
        viewController = _viewController
        viewController?.view.endEditing(true)
        
        let alertController: UIAlertController = UIAlertController(title: UtilsAppSetting.getLanguage(Global.LANGUAGE_PREFIX + "please select"), message: UtilsAppSetting.getLanguage(Global.LANGUAGE_PREFIX + "option to select"), preferredStyle: .actionSheet)
        
        let cameraAlertAction: UIAlertAction = UIAlertAction(title: UtilsAppSetting.getLanguage(Global.LANGUAGE_PREFIX + "from camera"), style: .default) { action -> Void in
            self.showCameraSelect()
        }
        alertController.addAction(cameraAlertAction)
        
        let photoAlertAction: UIAlertAction = UIAlertAction(title: UtilsAppSetting.getLanguage(Global.LANGUAGE_PREFIX + "from photo library"), style: .default)
        { action -> Void in
            self.showPhotoLibrarySelect()
        }
        alertController.addAction(photoAlertAction)
        alertController.addAction(UIAlertAction(title: UtilsAppSetting.getLanguage(Global.LANGUAGE_PREFIX + "cancel"), style: UIAlertAction.Style.default, handler: nil))
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func authorizeToAlbum(completion:@escaping (Bool)->Void) {
        if PHPhotoLibrary.authorizationStatus() != .authorized {
			UtilsLogger.log("Will request authorization")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    DispatchQueue.main.async(execute: {
                        completion(true)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        completion(false)
                    })
                }
            })
        } else {
            DispatchQueue.main.async(execute: {
                completion(true)
            })
        }
    }
    func noCamera(){
        let alertController = UIAlertController(
            title: UtilsAppSetting.getLanguage(Global.LANGUAGE_PREFIX + "no camare"),
            message: UtilsAppSetting.getLanguage(Global.LANGUAGE_PREFIX + "no camera description"),
            preferredStyle: .alert)
        let okAlertAction = UIAlertAction(
            title: UtilsAppSetting.getLanguage(Global.LANGUAGE_PREFIX + "ok"),
            style:.default,
            handler: nil)
        alertController.addAction(okAlertAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    func showCameraSelect() {
        weak var weakSelf = viewController
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.authorizeToAlbum { (authorized) in
                if authorized == true {
                    self.imagePickerController.allowsEditing = true
                    self.imagePickerController.sourceType = .camera
                    self.imagePickerController.cameraCaptureMode = .photo
                    self.imagePickerController.modalPresentationStyle = .fullScreen
                    weakSelf?.present(self.imagePickerController, animated: true, completion: nil)
                }
            }
        } else {
            noCamera()
        }
    }
    func showPhotoLibrarySelect () {
        weak var weakSelf = viewController
        self.authorizeToAlbum { (authorized) in
            if authorized == true {
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.sourceType = .photoLibrary
                weakSelf?.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
    }
}
