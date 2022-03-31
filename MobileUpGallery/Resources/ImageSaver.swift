import UIKit
import Photos

class ImageSaver {

    var error: Error?
    var isSuccessfullySaved: Bool = true
 
    func writeToPhotoAlbum(image: UIImage) {
        
        PHPhotoLibrary.shared().performChanges {
            _ = PHAssetChangeRequest.creationRequestForAsset(from: image)

        } completionHandler: { (success, error) in
            guard error != nil else {
                self.error = error
                self.isSuccessfullySaved = false
                return
            }
        }
    }
}
