import UIKit

class Alert {

    static func showAlert(title: String, message: String, actionToRetry: (()->Void)?, on vc: UIViewController) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
            if let action = actionToRetry {
                alertView.addAction(UIAlertAction(title: "Retry", style: .cancel) { _ in action()})
            } else {
                alertView.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            }
        DispatchQueue.main.async {
            vc.present(alertView, animated: true, completion: nil)
        }
    }
}
