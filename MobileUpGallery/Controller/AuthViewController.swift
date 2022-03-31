import UIKit
import SwiftyVK
import SwiftUI

class AuthViewController: UIViewController {

    
    @IBAction func authButtonTapped(_ sender: Any) {
        login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isAuthorized() {showGallery()}
    }
    
    private func login() {
        
        if isAuthorized() {showGallery()}
        
        VK.sessions.default.logIn(
            onSuccess: { _ in
                
                DispatchQueue.main.async { [weak self] in
                    self!.showGallery()
                }
            },
            onError: { error in
                Alert.showAlert(title: "Ошибка", message: "Авторизация не выполнена: \(error)", actionToRetry: nil, on: self)
            }
        )
    }
    
    private func isAuthorized() -> Bool {
        guard NetworkMonitor.shared.isConnected == true else {
            Alert.showAlert(title: "Ошибка", message: "Отсутствует подключение к сети", actionToRetry: nil, on: self)
            return false
        }
                
        if (VK.sessions.default.state == .authorized) {
            return true
        }
        
        return false
    }
    
    private func showGallery() {
        let rootVc = GalleryViewController(nibName: "GalleryView", bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootVc)
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true, completion: nil)
    }
}
