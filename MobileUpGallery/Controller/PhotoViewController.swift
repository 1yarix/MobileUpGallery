import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageToShow: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = imageToShow
        scrollView.delegate = self
        setupShareButton()
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.shadowImage = UIColor.systemGray5.image()
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.shadowImage = UIColor.systemBackground.image()
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    private func setupScrollView() {
        scrollView.isScrollEnabled = false
        scrollView.bounces = false
        scrollView.bouncesZoom = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.5
    }
    
    private func setupShareButton() {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareImage))
        button.tintColor = .label
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        self.navigationItem.rightBarButtonItem = button
    }
    
   @objc private func shareImage() {
       
       let items: [Any] = [imageToShow!]
       let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
       
       /* Костыли для обхода бага(?) на ios 13-14.4
         https://stackoverflow.com/questions/56903030/
         https://developer.apple.com/forums/thread/119482 */
       
       let fakeViewController = UIViewController()
       fakeViewController.modalPresentationStyle = .overFullScreen

       avc.completionWithItemsHandler = { [weak fakeViewController] _, _, _, _ in
         if let presentingViewController = fakeViewController?.presentingViewController {
         presentingViewController.dismiss(animated: false, completion: nil)
         } else {
         fakeViewController?.dismiss(animated: false, completion: nil)
         }
       }
       present(fakeViewController, animated: true) { [weak fakeViewController] in
         fakeViewController?.present(avc, animated: true, completion: nil)
       }
   }
}

extension PhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
