import UIKit

class AuthViewController: UIViewController {

    @IBAction func authButtonTapped(_ sender: Any) {
        
        let rootVc = GalleryViewController(nibName: "GalleryView", bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootVc)
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
