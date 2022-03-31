import UIKit
import SwiftUI

class CustomSavePhotoActivity: UIActivity {
    
    var items: [Any] = []
    var isComplete = false
    var error: Error?
    

    override var activityTitle: String? {
        return "Save Image"
    }
    
    override var activityImage: UIImage? {
        return UIImage(systemName: "square.and.arrow.down")
    }
    
    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("CustomSavePhotoActivity")
    }
    
    override class var activityCategory: UIActivity.Category {
        return .action
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        self.items = activityItems
    }
    
    override func perform() {
        let saver = ImageSaver()
        saver.writeToPhotoAlbum(image: items[0] as! UIImage)
        
        self.isComplete = saver.isSuccessfullySaved
        
        if !isComplete{
            self.error = saver.error
        }
                
        activityDidFinish(true)
    }
}
