import SwiftyVK
import UIKit

var vkDelegate: VKDelegate!

final class VKDelegate: SwiftyVKDelegate {
    
    let appId = "8118704"
    let scopes: Scopes = []
    
    init() {
        VK.setUp(appId: appId, delegate: self)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }

    func vkNeedToPresent(viewController: VKViewController) {
        if let rootController = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController {
            rootController.present(viewController, animated: true)
        }
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        print("token created in session \(sessionId) with info \(info)")
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        print("token updated in session \(sessionId) with info \(info)")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        print("token removed in session \(sessionId)")
    }
}
