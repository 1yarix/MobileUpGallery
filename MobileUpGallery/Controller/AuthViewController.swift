import UIKit
import SwiftyVK

class AuthViewController: UIViewController {

    
    @IBAction func authButtonTapped(_ sender: Any) {
        login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = VK.sessions.default.accessToken {
            showGallery()
        }
    }
    
    private func login() {
        VK.sessions.default.logIn(
            onSuccess: { _ in
                DispatchQueue.main.async { [weak self] in
                    self!.showGallery()
                }
            },
            onError: { error in
                print(error)
            }
        )
        
        if (VK.sessions.default.accessToken == nil) {
            // Alert
        }
    }
    
    private func showGallery() {
        let rootVc = GalleryViewController(nibName: "GalleryView", bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootVc)
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true, completion: nil)
    }
}
