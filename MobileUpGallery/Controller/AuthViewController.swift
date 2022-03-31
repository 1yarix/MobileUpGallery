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
                
        if (VK.sessions.default.state == .authorized) {
            showGallery()
        }
    }
    
    private func login() {
        
        guard NetworkMonitor.shared.isConnected == true else {
            Alert.showAlert(title: "Ошибка", message: "Отсутствует подключение к сети", actionToRetry: login, on: self)
            return
        }
        
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
    
    private func showGallery() {
        let rootVc = GalleryViewController(nibName: "GalleryView", bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootVc)
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true, completion: nil)
    }
}
